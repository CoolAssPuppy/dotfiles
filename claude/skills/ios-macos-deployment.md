# iOS/macOS App Store Deployment Expert

You are an expert in iOS and macOS app deployment to the App Store and TestFlight using Fastlane automation. This skill provides comprehensive, battle-tested knowledge for setting up and troubleshooting deployment pipelines.

## Core expertise

### 1. Ruby and Fastlane environment

#### Ruby version compatibility
- **Recommended:** Ruby 3.3.x
- **Ruby 3.4+ issues:**
  - `abbrev` gem removed from stdlib, add `gem "abbrev"` to Gemfile
  - `ostruct` gem will be removed in 3.5, add `gem "ostruct"` to Gemfile
  - `base64` gem removed, may affect some dependencies
- **Ruby 3.2 and earlier:** Generally stable with Fastlane
- **Bundler:** Always use `bundle exec fastlane` to ensure correct gem versions

#### Essential Gemfile
```ruby
source "https://rubygems.org"
gem "fastlane", "~> 2.219"
gem "abbrev"   # Ruby 3.4+ compatibility
gem "ostruct"  # Ruby 3.4+ compatibility
gem "dotenv"   # Environment variable management
```

### 2. Project structure detection

#### Xcode projects vs workspaces
- **If .xcworkspace exists:** Always use the workspace (CocoaPods or SPM with multiple packages)
- **If only .xcodeproj:** Use the project file
- **Command:** `xcodebuild -list -workspace MyApp.xcworkspace` or `-project MyApp.xcodeproj`

#### Identifying build configuration
```bash
# List schemes
xcodebuild -list -project MyApp.xcodeproj

# Get build settings
xcodebuild -project MyApp.xcodeproj -showBuildSettings

# Find bundle identifier
grep -A 1 "PRODUCT_BUNDLE_IDENTIFIER" MyApp.xcodeproj/project.pbxproj

# Find team ID
grep -A 1 "DEVELOPMENT_TEAM" MyApp.xcodeproj/project.pbxproj
```

### 3. Versioning strategy

#### The problem with agvtool
- Fastlane's `increment_build_number` and `increment_version_number` actions rely on Apple's `agvtool`
- agvtool requires strict project configuration (Apple Generic Versioning)
- Often fails with "CURRENT_PROJECT_VERSION not set" errors
- Not reliable for automated builds

#### The solution: Direct plist manipulation
**Always use plutil commands instead of agvtool-based actions.**

```ruby
# Get current version from Info.plist
version = sh("plutil -extract CFBundleShortVersionString raw ../AppName/Info.plist").strip

# Get current build number from Info.plist
build_number = sh("plutil -extract CFBundleVersion raw ../AppName/Info.plist").strip

# Increment build number
new_build = build_number.to_i + 1
sh("plutil -replace CFBundleVersion -string '#{new_build}' ../AppName/Info.plist")

# Bump patch version (1.0.0 -> 1.0.1)
parts = version.split('.').map(&:to_i)
new_version = "#{parts[0]}.#{parts[1]}.#{parts[2] + 1}"
sh("plutil -replace CFBundleShortVersionString -string '#{new_version}' ../AppName/Info.plist")

# Bump minor version (1.0.0 -> 1.1.0)
new_version = "#{parts[0]}.#{parts[1] + 1}.0"

# Bump major version (1.0.0 -> 2.0.0)
new_version = "#{parts[0] + 1}.0.0"
```

#### Required Xcode project settings
Add these to BOTH Debug and Release build configurations in project.pbxproj:
```
CURRENT_PROJECT_VERSION = 1;
MARKETING_VERSION = 1.0.0;
```

This enables version visibility in Xcode but doesn't require agvtool to work.

### 4. Path handling in Fastlane

#### Critical understanding
**Fastlane commands execute from the `fastlane/` directory**, not the project root.

This means:
- Project files are at `../ProjectName.xcodeproj`
- Info.plist is at `../ProjectName/Info.plist`
- .env file is at `../.env`
- But API keys should be in `fastlane/` directory: `./app_store_connect_api_key.p8`

#### Path resolution best practices
```ruby
# In Fastfile, use File.expand_path for paths outside fastlane/
env_file = File.expand_path('../.env', __dir__)
api_key_path = File.expand_path("../fastlane/app_store_connect_api_key.p8", __dir__)

# For files in project root (relative to fastlane/)
XCODEPROJ = "MyApp.xcodeproj"  # Fastlane will look in ../ automatically

# For Info.plist in build lanes
sh("plutil -extract ... ../MyApp/Info.plist")
```

### 5. Environment variable management

#### The problem
Fastlane doesn't automatically load .env files. Environment variables set in .env won't be available unless explicitly loaded.

#### The solution
```ruby
# At the very top of Fastfile, BEFORE default_platform
require 'dotenv'
env_file = File.expand_path('../.env', __dir__)
Dotenv.load(env_file) if File.exist?(env_file)

default_platform(:ios)  # or :mac
```

#### Required environment variables
```bash
# .env file
FASTLANE_USER=your.email@example.com
FASTLANE_TEAM_ID=ABCD123456
FASTLANE_ITC_TEAM_ID=ABCD123456

# App Store Connect API (preferred over Apple ID)
APP_STORE_CONNECT_API_KEY_ID=ABC123DEF4
APP_STORE_CONNECT_API_ISSUER_ID=abcd1234-ef56-78gh-90ij-klmnopqrstuv
APP_STORE_CONNECT_API_KEY_PATH=fastlane/app_store_connect_api_key.p8

# Optional
FASTLANE_SKIP_2FA_UPGRADE=true
TESTFLIGHT_CHANGELOG=New build from CI/CD
```

### 6. Code signing for iOS

#### Automatic signing (recommended for solo developers)
```ruby
build_ios_app(
  scheme: "MyApp",
  export_method: "app-store",
  xcargs: "CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM=ABCD123456 -allowProvisioningUpdates"
)
```

#### Manual signing (for teams using Match)
```ruby
sync_code_signing(
  type: "appstore",
  app_identifier: "com.company.app"
)

build_ios_app(
  scheme: "MyApp",
  export_method: "app-store",
  export_options: {
    provisioningProfiles: {
      "com.company.app" => "match AppStore com.company.app"
    }
  }
)
```

### 7. Code signing for macOS

#### Critical differences from iOS
- macOS requires **TWO separate certificates**:
  1. "Apple Distribution" (for signing the .app)
  2. "Mac Installer Distribution" (for signing the .pkg installer)
- Without BOTH certificates, export will fail with "No signing certificate found"

#### Automatic signing (recommended)
```ruby
gym(  # build_mac_app is an alias for gym
  scheme: "MyApp",
  output_directory: "./fastlane/builds",
  clean: true,
  export_method: "app-store",
  xcargs: "CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM=ABCD123456 -allowProvisioningUpdates"
)
```

#### Required Xcode settings for macOS
```
ENABLE_HARDENED_RUNTIME = YES;
CODE_SIGN_STYLE = Automatic;
```

#### Sandboxing and entitlements
macOS App Store apps MUST be sandboxed. Create `App.entitlements` file with required entitlements:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
    <!-- Add other required entitlements -->
</dict>
</plist>
```

### 8. App Store Connect API authentication

#### Why use API keys over Apple ID
- No 2FA prompts during automation
- More secure for CI/CD
- Doesn't require session management
- Can be scoped to specific access levels

#### Creating API keys
1. Go to App Store Connect → Users and Access → Keys
2. Click "+" to generate new key
3. Give it "Admin" or "App Manager" access
4. Download the .p8 file (ONLY available once!)
5. Note the Key ID and Issuer ID

#### Using API keys in Fastlane
```ruby
api_key = app_store_connect_api_key(
  key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
  issuer_id: ENV["APP_STORE_CONNECT_API_ISSUER_ID"],
  key_filepath: File.expand_path("../fastlane/app_store_connect_api_key.p8", __dir__)
)

upload_to_testflight(
  api_key: api_key,
  app_identifier: "com.company.app",
  skip_waiting_for_build_processing: true,
  skip_submission: true
)
```

### 9. TestFlight upload optimization

#### The waiting problem
By default, `upload_to_testflight` waits for Apple to process the build (5-30 minutes). This is unnecessary for automated deployments.

#### Solution
```ruby
upload_to_testflight(
  api_key: api_key,
  app_identifier: "com.company.app",
  skip_waiting_for_build_processing: true,  # Don't wait for processing
  skip_submission: true,                     # Don't wait for API confirmation
  distribute_external: false,                # Only internal testers initially
  changelog: ENV["TESTFLIGHT_CHANGELOG"] || "New build"
)
```

This makes uploads complete in seconds instead of minutes. The build will still be processed by Apple and appear in TestFlight within 10-15 minutes.

### 10. Complete Fastfile template (iOS)

```ruby
# Fastfile for iOS App
require 'dotenv'
env_file = File.expand_path('../.env', __dir__)
Dotenv.load(env_file) if File.exist?(env_file)

default_platform(:ios)

platform :ios do
  SCHEME = "MyApp"
  XCODEPROJ = "MyApp.xcodeproj"
  APP_IDENTIFIER = "com.company.myapp"

  desc "Run tests"
  lane :test do
    run_tests(
      scheme: SCHEME,
      device: "iPhone 15 Pro"
    )
  end

  desc "Build app"
  lane :build do
    # Increment build number
    build_number = sh("plutil -extract CFBundleVersion raw ../#{SCHEME}/Info.plist").strip.to_i
    new_build = build_number + 1
    sh("plutil -replace CFBundleVersion -string '#{new_build}' ../#{SCHEME}/Info.plist")

    # Build
    build_ios_app(
      scheme: SCHEME,
      export_method: "app-store",
      xcargs: "CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM=#{ENV['FASTLANE_TEAM_ID']} -allowProvisioningUpdates"
    )
  end

  desc "Deploy to TestFlight"
  lane :beta do
    build

    api_key = app_store_connect_api_key(
      key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
      issuer_id: ENV["APP_STORE_CONNECT_API_ISSUER_ID"],
      key_filepath: File.expand_path("../fastlane/app_store_connect_api_key.p8", __dir__)
    )

    upload_to_testflight(
      api_key: api_key,
      skip_waiting_for_build_processing: true,
      skip_submission: true
    )
  end

  desc "Bump patch version"
  lane :bump_patch do
    version = sh("plutil -extract CFBundleShortVersionString raw ../#{SCHEME}/Info.plist").strip
    parts = version.split('.').map(&:to_i)
    new_version = "#{parts[0]}.#{parts[1]}.#{parts[2] + 1}"
    sh("plutil -replace CFBundleShortVersionString -string '#{new_version}' ../#{SCHEME}/Info.plist")
    git_commit(path: ["#{SCHEME}/Info.plist"], message: "Bump version to #{new_version}")
  end
end
```

### 11. Complete Fastfile template (macOS)

```ruby
# Fastfile for macOS App
require 'dotenv'
env_file = File.expand_path('../.env', __dir__)
Dotenv.load(env_file) if File.exist?(env_file)

default_platform(:mac)

platform :mac do
  SCHEME = "MyApp"
  XCODEPROJ = "MyApp.xcodeproj"
  APP_IDENTIFIER = "com.company.myapp"

  desc "Run tests"
  lane :test do
    run_tests(
      scheme: SCHEME
    )
  end

  desc "Build app"
  lane :build do
    # Increment build number
    build_number = sh("plutil -extract CFBundleVersion raw ../#{SCHEME}/Info.plist").strip.to_i
    new_build = build_number + 1
    sh("plutil -replace CFBundleVersion -string '#{new_build}' ../#{SCHEME}/Info.plist")

    # Build for Mac App Store
    gym(
      scheme: SCHEME,
      output_directory: "./fastlane/builds",
      clean: true,
      export_method: "app-store",
      xcargs: "CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM=#{ENV['FASTLANE_TEAM_ID']} -allowProvisioningUpdates"
    )
  end

  desc "Deploy to TestFlight"
  lane :beta do
    build

    api_key = app_store_connect_api_key(
      key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
      issuer_id: ENV["APP_STORE_CONNECT_API_ISSUER_ID"],
      key_filepath: File.expand_path("../fastlane/app_store_connect_api_key.p8", __dir__)
    )

    upload_to_testflight(
      api_key: api_key,
      skip_waiting_for_build_processing: true,
      skip_submission: true
    )
  end

  desc "Bump patch version"
  lane :bump_patch do
    version = sh("plutil -extract CFBundleShortVersionString raw ../#{SCHEME}/Info.plist").strip
    parts = version.split('.').map(&:to_i)
    new_version = "#{parts[0]}.#{parts[1]}.#{parts[2] + 1}"
    sh("plutil -replace CFBundleShortVersionString -string '#{new_version}' ../#{SCHEME}/Info.plist")
    git_commit(path: ["#{SCHEME}/Info.plist"], message: "Bump version to #{new_version}")
  end
end
```

### 12. Common errors and solutions

#### Error: "cannot load such file -- abbrev"
**Cause:** Ruby 3.4+ removed `abbrev` from default gems
**Solution:** Add to Gemfile:
```ruby
gem "abbrev"
gem "ostruct"
```

#### Error: "Could not find Xcode project"
**Cause:** Path is incorrect, Fastlane runs from fastlane/ directory
**Solution:** Use `../ProjectName.xcodeproj` or let Fastlane auto-detect

#### Error: "Apple Generic Versioning is not enabled"
**Cause:** Using agvtool-based actions without proper setup
**Solution:** Use plutil commands instead of agvtool actions

#### Error: "No signing certificate 'Mac Installer Distribution' found"
**Cause:** Missing required certificate for macOS App Store
**Solution:** Create "Mac Installer Distribution" certificate in Apple Developer portal

#### Error: "No profiles for 'com.company.app' were found"
**Cause:** No provisioning profile for automatic signing
**Solution:** Add `-allowProvisioningUpdates` to xcargs

#### Error: "Error packaging up the application"
**Cause:** Export failed during archive export
**Solution:** Check export_method matches signing certificate type

#### Error: Fastlane hangs after upload
**Cause:** Waiting for Apple's processing
**Solution:** Add `skip_waiting_for_build_processing: true` and `skip_submission: true`

#### Error: "Could not retrieve response as fastlane runs in non-interactive mode"
**Cause:** Fastlane can't find Fastfile
**Solution:** Ensure you're running from project root, not inside fastlane/ directory

### 13. CI/CD integration

#### GitHub Actions workflow (TestFlight)
```yaml
name: Deploy to TestFlight

on:
  push:
    branches: [main]
    paths:
      - 'MyApp/**'
      - '.github/workflows/testflight.yml'

jobs:
  deploy:
    runs-on: macos-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: .

      - name: Create .env file
        run: |
          cat > .env << EOF
          FASTLANE_USER=${{ secrets.FASTLANE_USER }}
          FASTLANE_TEAM_ID=${{ secrets.FASTLANE_TEAM_ID }}
          FASTLANE_ITC_TEAM_ID=${{ secrets.FASTLANE_ITC_TEAM_ID }}
          APP_STORE_CONNECT_API_KEY_ID=${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
          APP_STORE_CONNECT_API_ISSUER_ID=${{ secrets.APP_STORE_CONNECT_API_ISSUER_ID }}
          APP_STORE_CONNECT_API_KEY_PATH=fastlane/app_store_connect_api_key.p8
          EOF

      - name: Create API Key
        run: |
          mkdir -p fastlane
          echo "${{ secrets.APP_STORE_CONNECT_API_KEY }}" > fastlane/app_store_connect_api_key.p8

      - name: Deploy to TestFlight
        run: bundle exec fastlane beta
```

#### Required GitHub secrets
- `FASTLANE_USER`: Apple ID email
- `FASTLANE_TEAM_ID`: Team ID
- `FASTLANE_ITC_TEAM_ID`: iTunes Connect team ID
- `APP_STORE_CONNECT_API_KEY_ID`: API key ID
- `APP_STORE_CONNECT_API_ISSUER_ID`: Issuer ID
- `APP_STORE_CONNECT_API_KEY`: Contents of .p8 file (base64 or raw)

### 14. Best practices

#### Project setup
1. Always use .xcworkspace if it exists
2. Enable automatic code signing
3. Set MARKETING_VERSION and CURRENT_PROJECT_VERSION in project
4. Keep Info.plist as the source of truth for version/build
5. Use .env files for secrets (never commit)
6. Add .env to .gitignore

#### Fastfile structure
1. Load dotenv at the top
2. Define constants for scheme, project, identifier
3. Use plutil for version management
4. Use File.expand_path for path handling
5. Always use api_key for authentication
6. Skip waiting for build processing

#### Version management
1. Auto-increment build number on every build
2. Manually bump version for releases (semantic versioning)
3. Commit version bumps to git
4. Tag releases in git

#### Testing
1. Run tests before building
2. Run tests in CI/CD on every PR
3. Don't deploy if tests fail

### 15. Checklist for new project setup

**Before running Fastlane:**
- [ ] Bundle identifier registered in Apple Developer portal
- [ ] App created in App Store Connect
- [ ] "Apple Distribution" certificate installed
- [ ] "Mac Installer Distribution" certificate installed (macOS only)
- [ ] App Store Connect API key created and downloaded
- [ ] Team ID identified
- [ ] .env file created with all required variables
- [ ] Gemfile created with abbrev, ostruct, dotenv
- [ ] Fastfile created with proper path handling
- [ ] MARKETING_VERSION and CURRENT_PROJECT_VERSION set in project

**First deployment:**
- [ ] Run `bundle install`
- [ ] Test with `bundle exec fastlane prep` (if defined)
- [ ] Run first build locally: `bundle exec fastlane build`
- [ ] Verify build succeeds without errors
- [ ] Run first TestFlight upload: `bundle exec fastlane beta`
- [ ] Check App Store Connect for build

**CI/CD setup:**
- [ ] GitHub Actions workflow created
- [ ] All secrets added to GitHub repository
- [ ] API key added as secret
- [ ] Test workflow with manual trigger
- [ ] Verify automatic deployment on push to main

### 16. Advanced topics

#### Multi-target apps (app + extensions)
```ruby
# Build multiple targets with same version
["MyApp", "MyAppWidget", "MyAppExtension"].each do |target|
  sh("plutil -replace CFBundleVersion -string '#{new_build}' ../#{target}/Info.plist")
end
```

#### Universal binaries (Apple Silicon + Intel)
```ruby
gym(
  scheme: SCHEME,
  xcargs: "ARCHS='arm64 x86_64'"  # Build for both architectures
)
```

#### Localization
Fastlane can manage screenshots and metadata for multiple locales:
```ruby
deliver(
  metadata_path: "./fastlane/metadata",
  screenshots_path: "./fastlane/screenshots"
)
```

#### Beta tester management
```ruby
upload_to_testflight(
  api_key: api_key,
  groups: ["Internal", "Beta Testers"],
  distribute_external: true,  # Submit for external testing
  beta_app_review_info: {
    contact_email: "support@company.com",
    contact_first_name: "John",
    contact_last_name: "Doe",
    contact_phone: "5558675309",
    demo_account_required: false
  }
)
```

## When to use this skill

Use this skill when:
- Setting up App Store deployment for the first time
- Troubleshooting Fastlane build or upload issues
- Implementing CI/CD for iOS/macOS apps
- Dealing with code signing problems
- Version management issues
- Path resolution errors in Fastlane
- Ruby compatibility issues with Fastlane
- Migrating from manual deployment to automated
- Setting up TestFlight beta testing
- Preparing for App Store submission

## What this skill cannot do

This skill does not cover:
- Swift/Objective-C code development
- UI/UX design
- App Store optimization (ASO) strategies
- Marketing and monetization
- App Store review process appeals
- Legal compliance (GDPR, COPPA, etc.)

## References and resources

- Fastlane Documentation: https://docs.fastlane.tools
- Apple Developer Portal: https://developer.apple.com
- App Store Connect: https://appstoreconnect.apple.com
- Fastlane GitHub Issues: https://github.com/fastlane/fastlane/issues
- Ruby Changelog: https://www.ruby-lang.org/en/news/
- Xcode Release Notes: https://developer.apple.com/documentation/xcode-release-notes
