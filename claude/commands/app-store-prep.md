# App Store Deployment Automation Setup

You are setting up a complete, production-ready App Store deployment automation system for this app. This is a critical production task that requires thoroughness and accuracy.

## Your mission

Create a fully automated deployment pipeline that handles everything from build to App Store submission, with clear documentation on the few manual steps the user must complete.

## Phase 1: Discovery and analysis

1. **Locate the iOS/macOS project**
   - Search the current directory and subdirectories for .xcodeproj or .xcworkspace files
   - This might be a monorepo with web, Android, and iOS projects
   - Common locations to check:
     - ./ios/
     - ./mobile/ios/
     - ./apps/ios/
     - ./packages/mobile/
     - ./native/ios/
     - Root directory
   - If multiple Xcode projects found, list them and ask which one to configure
   - Once identified, set this as the PROJECT_ROOT for all subsequent operations
   - Display the full path clearly so user can confirm it's correct

2. **Monorepo structure detection**
   - Check if project is in a monorepo by looking for:
     - package.json in parent directories
     - lerna.json, nx.json, or pnpm-workspace.yaml
     - Multiple platform folders (android/, web/, ios/)
   - If monorepo detected, note this in documentation
   - Adjust all paths to be relative to PROJECT_ROOT, not repo root

3. **Project analysis** (within PROJECT_ROOT)
   - Identify if this is iOS, macOS, tvOS, or visionOS
   - Find the Xcode project/workspace file
   - Prefer .xcworkspace over .xcodeproj if both exist (CocoaPods or SPM)
   - Identify all targets and schemes using `xcodebuild -list`
   - Extract from project.pbxproj:
     - Bundle identifier(s) for all targets
     - Team ID (DEVELOPMENT_TEAM)
     - Current version (MARKETING_VERSION) and build number (CURRENT_PROJECT_VERSION)
     - Code signing style (Automatic vs Manual)
     - Minimum deployment target
     - Enabled capabilities and entitlements
   - Check for Swift Package Manager dependencies
   - Check for CocoaPods (Podfile presence)
   - Check for Carthage (Cartfile presence)
   - Identify if using SwiftUI, UIKit, or AppKit
   - Check current directory structure

4. **Environment audit**
   - Verify Ruby is installed:
     - Check version with `ruby --version`
     - Prefer 3.3.x (warn if 3.4+ due to stdlib changes)
     - Warn if < 3.0 (outdated)
   - Verify Xcode is installed:
     - Check with `xcode-select -p`
     - Verify version is recent (15.0+ recommended)
     - Check that command line tools are installed
   - Verify Xcode license is accepted: `sudo xcodebuild -license`
   - Check for existing Fastlane setup (don't overwrite without asking)
   - Check Git repository status (warn about uncommitted changes)
   - Verify bundle identifier is registered in Apple Developer portal
   - Check App Store Connect access
   - For macOS apps: Verify hardened runtime is enabled
   - Check for Privacy Manifest (PrivacyInfo.xcprivacy) if iOS 17+ target

5. **Certificate and provisioning verification**
   - Run `security find-identity -v -p codesigning` to list all code signing identities
   - Check certificate validity (expiration dates)
   - For iOS:
     - Check for "Apple Distribution" certificate
     - Check for "Apple Development" certificate (for local testing)
     - Warn if certificates expire within 30 days
   - For macOS:
     - Check for "Apple Distribution" certificate
     - Check for "Mac Installer Distribution" certificate (REQUIRED for App Store)
     - Check for "Developer ID Application" certificate (optional, for non-App Store)
     - Check for "Developer ID Installer" certificate (optional, for non-App Store)
   - Check provisioning profiles:
     - For manual signing: Verify profiles exist in ~/Library/MobileDevice/Provisioning Profiles/
     - Check profile expiration dates
     - Verify profiles match bundle identifiers
   - If missing certificates, provide step-by-step instructions:
     - Link to Apple Developer portal
     - Explain CSR creation process
     - Show how to download and install
   - Warn user if critical certificates are missing before proceeding

## Phase 2: Fastlane installation and configuration

**CRITICAL: All Fastlane files go in PROJECT_ROOT, not repo root**

1. **Create Gemfile with Ruby 3.4+ compatibility** (in PROJECT_ROOT)
   ```ruby
   source "https://rubygems.org"
   gem "fastlane", "~> 2.219"
   gem "abbrev"  # Ruby 3.4+ compatibility - removed from stdlib
   gem "ostruct" # Ruby 3.4+ compatibility - will be removed in 3.5
   gem "dotenv"  # Environment variable management
   ```

   Explanation:
   - Ruby 3.4+ removed abbrev and ostruct from default gems
   - Without these, Fastlane will fail with "cannot load such file" errors
   - dotenv is critical for loading .env files (Fastlane doesn't auto-load them)

2. **Install dependencies**
   - Run `bundle install` from PROJECT_ROOT to create Gemfile.lock
   - This creates vendor/bundle with all gems
   - Always use `bundle exec fastlane` to ensure correct gem versions

3. **Configure Appfile** (in PROJECT_ROOT/fastlane/)
   ```ruby
   app_identifier("com.company.app") # Bundle identifier
   apple_id("user@example.com")      # Apple ID
   team_id("ABCD123456")              # Developer Portal Team ID
   itc_team_id("ABCD123456")          # App Store Connect Team ID (if different)
   ```

4. **Create comprehensive Fastfile** (in PROJECT_ROOT/fastlane/)

   **CRITICAL: Environment variable loading**
   At the very top of Fastfile, BEFORE default_platform:
   ```ruby
   require 'dotenv'
   env_file = File.expand_path('../.env', __dir__)
   Dotenv.load(env_file) if File.exist?(env_file)

   default_platform(:ios)  # or :mac
   ```

   Without this, ENV variables won't be available and authentication will fail.

   **CRITICAL: Path handling**
   Fastlane runs from the fastlane/ directory, so:
   - Project files: `../ProjectName.xcodeproj` (relative to fastlane/)
   - Info.plist: `../ProjectName/Info.plist`
   - .env file: `../.env`
   - API key: `File.expand_path("../fastlane/app_store_connect_api_key.p8", __dir__)`

   Build these lanes:

   **prep lane**: Pre-flight checks
   - Verify environment variables are set
   - Check certificates are available using `security find-identity`
   - Validate provisioning profiles (for macOS, ensure Mac Installer Distribution exists)
   - Ensure git working directory is clean
   - Check that version numbers follow semantic versioning
   - Verify we're in the correct directory (PROJECT_ROOT)

   **test lane**: Run all tests
   - Run unit tests for all schemes
   - Run UI tests if they exist
   - Generate test report
   - Fail fast if any tests fail

   **bump_patch/bump_minor/bump_major lanes**: Version management

   **CRITICAL: Never use agvtool-based actions**
   The increment_build_number and increment_version_number actions fail with "Apple Generic Versioning is not enabled". Always use plutil commands directly:

   ```ruby
   desc "Bump patch version"
   lane :bump_patch do
     # Get current version from Info.plist
     version = sh("plutil -extract CFBundleShortVersionString raw ../#{SCHEME}/Info.plist").strip

     # Calculate new version
     parts = version.split('.').map(&:to_i)
     new_version = "#{parts[0]}.#{parts[1]}.#{parts[2] + 1}"

     # Update Info.plist
     sh("plutil -replace CFBundleShortVersionString -string '#{new_version}' ../#{SCHEME}/Info.plist")

     # Commit version bump
     git_commit(path: ["#{SCHEME}/Info.plist"], message: "Bump version to #{new_version}")
     add_git_tag(tag: "v#{new_version}")
   end

   desc "Bump minor version"
   lane :bump_minor do
     version = sh("plutil -extract CFBundleShortVersionString raw ../#{SCHEME}/Info.plist").strip
     parts = version.split('.').map(&:to_i)
     new_version = "#{parts[0]}.#{parts[1] + 1}.0"
     sh("plutil -replace CFBundleShortVersionString -string '#{new_version}' ../#{SCHEME}/Info.plist")
     git_commit(path: ["#{SCHEME}/Info.plist"], message: "Bump version to #{new_version}")
     add_git_tag(tag: "v#{new_version}")
   end

   desc "Bump major version"
   lane :bump_major do
     version = sh("plutil -extract CFBundleShortVersionString raw ../#{SCHEME}/Info.plist").strip
     parts = version.split('.').map(&:to_i)
     new_version = "#{parts[0] + 1}.0.0"
     sh("plutil -replace CFBundleShortVersionString -string '#{new_version}' ../#{SCHEME}/Info.plist")
     git_commit(path: ["#{SCHEME}/Info.plist"], message: "Bump version to #{new_version}")
     add_git_tag(tag: "v#{new_version}")
   end
   ```

   **build lane**: Build app

   For iOS:
   ```ruby
   desc "Build iOS app"
   lane :build do
     # Increment build number using plutil
     build_number = sh("plutil -extract CFBundleVersion raw ../#{SCHEME}/Info.plist").strip.to_i
     new_build = build_number + 1
     sh("plutil -replace CFBundleVersion -string '#{new_build}' ../#{SCHEME}/Info.plist")

     # Build with automatic code signing
     build_ios_app(
       scheme: SCHEME,
       export_method: "app-store",
       xcargs: "CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM=#{ENV['FASTLANE_TEAM_ID']} -allowProvisioningUpdates"
     )
   end
   ```

   For macOS:
   ```ruby
   desc "Build macOS app"
   lane :build do
     # Increment build number using plutil
     build_number = sh("plutil -extract CFBundleVersion raw ../#{SCHEME}/Info.plist").strip.to_i
     new_build = build_number + 1
     sh("plutil -replace CFBundleVersion -string '#{new_build}' ../#{SCHEME}/Info.plist")

     # Build for Mac App Store (requires both Apple Distribution and Mac Installer Distribution certificates)
     gym(
       scheme: SCHEME,
       output_directory: "./fastlane/builds",
       clean: true,
       export_method: "app-store",
       xcargs: "CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM=#{ENV['FASTLANE_TEAM_ID']} -allowProvisioningUpdates"
     )
   end
   ```

   **beta lane**: TestFlight deployment

   **CRITICAL: Upload optimization**
   By default, upload_to_testflight waits for Apple to process the build (5-30 minutes). This is unnecessary.

   ```ruby
   desc "Deploy to TestFlight"
   lane :beta do
     build

     # Use App Store Connect API for authentication (no 2FA prompts)
     api_key = app_store_connect_api_key(
       key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
       issuer_id: ENV["APP_STORE_CONNECT_API_ISSUER_ID"],
       key_filepath: File.expand_path("../fastlane/app_store_connect_api_key.p8", __dir__)
     )

     # Upload without waiting (completes in seconds instead of minutes)
     upload_to_testflight(
       api_key: api_key,
       app_identifier: APP_IDENTIFIER,
       skip_waiting_for_build_processing: true,  # Don't wait for Apple processing
       skip_submission: true,                     # Don't wait for API confirmation
       distribute_external: false,                # Only internal testers initially
       changelog: ENV["TESTFLIGHT_CHANGELOG"] || "New build"
     )

     # Build will still be processed and appear in TestFlight within 10-15 minutes
   end
   ```

   **release lane**: Production App Store deployment
   - Prompt for confirmation (safety check)
   - Run tests first
   - Build and archive
   - Export IPA/pkg
   - Upload to App Store Connect
   - Submit for review (optional flag)
   - Generate release notes from changelog

   **metadata lane**: Update App Store metadata
   - Update descriptions, keywords, screenshots
   - Handle multiple localizations if present
   - Upload promotional artwork

5. **Update Xcode project settings**
   Add these to BOTH Debug and Release build configurations in project.pbxproj:
   ```
   CURRENT_PROJECT_VERSION = 1;
   MARKETING_VERSION = 1.0.0;
   ```
   This enables version visibility in Xcode but doesn't require agvtool to work.

## Phase 3: Code signing setup

**For Solo Developers (Recommended)**

1. **Use Xcode automatic code signing**
   - Verify project has CODE_SIGN_STYLE set to "Automatic"
   - Confirm DEVELOPMENT_TEAM is set correctly
   - Document in DEPLOY-STEPS.md that user needs to enable "Automatically manage signing" in Xcode
   - No need for Match, cert, or sigh for solo developers
   - Fastlane will use Xcode's automatic signing when building
   - Add `-allowProvisioningUpdates` flag to xcargs to auto-create provisioning profiles

2. **For macOS**: Ensure both certificates exist
   - "Apple Distribution" (for signing the .app)
   - "Mac Installer Distribution" (for signing the .pkg installer)
   - Without BOTH, export will fail with "No signing certificate found"

## Phase 4: Environment and secrets management

**Place .env files in PROJECT_ROOT, not repo root**

1. **Create .env files** (in PROJECT_ROOT)

   `.env.default` (template, checked into git):
   ```bash
   # Apple Developer Account
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

   `.env` (actual secrets, gitignored):
   - Copy from .env.default and fill in your real Apple ID and Team ID values

   **Creating App Store Connect API Key:**
   1. Go to App Store Connect → Users and Access → Keys
   2. Click "+" to generate new key
   3. Give it "Admin" or "App Manager" access
   4. Download the .p8 file (ONLY available once!)
   5. Save as `fastlane/app_store_connect_api_key.p8`
   6. Note the Key ID and Issuer ID for .env file

2. **Update .gitignore**
   Add to existing repo .gitignore or create in PROJECT_ROOT:
   ```gitignore
   # Environment and secrets
   .env
   .env.local

   # Fastlane
   fastlane/report.xml
   fastlane/Preview.html
   fastlane/screenshots/**/*.png
   fastlane/test_output
   fastlane/builds
   */fastlane/report.xml
   */fastlane/Preview.html
   */fastlane/test_output
   */fastlane/builds
   */fastlane/*.p8

   # Ruby/Bundler
   */Gemfile.lock
   */vendor/bundle
   vendor/bundle
   Gemfile.lock

   # Build artifacts
   *.ipa
   *.dSYM.zip
   *.app
   *.pkg
   ```

## Phase 5: Automation scripts

**Create scripts in PROJECT_ROOT that work from any directory**

1. **Create deploy.sh script** (in PROJECT_ROOT)
   A master deployment script that:
   - Auto-detects its own location to find PROJECT_ROOT
   - Uses `cd "$(dirname "$0")"` to navigate to script directory
   - Shows current working directory clearly at start
   - Checks prerequisites (Ruby, Bundler, environment variables)
   - Validates git status (no uncommitted changes for production)
   - Prompts user for deployment type (beta or release)
   - For releases, prompts for version bump type (patch/minor/major)
   - Asks for changelog entry
   - Runs appropriate Fastlane lane using `bundle exec`
   - Handles errors gracefully with clear messages
   - Provides success confirmation with next steps
   - Makes it colorful and user-friendly
   - Works whether called from PROJECT_ROOT or repo root

   Example structure:
   ```bash
   #!/bin/bash
   set -e

   # Navigate to script directory (PROJECT_ROOT)
   cd "$(dirname "$0")"
   echo "Working in: $(pwd)"

   # Check prerequisites
   command -v ruby >/dev/null 2>&1 || { echo "Ruby not installed"; exit 1; }
   command -v bundle >/dev/null 2>&1 || { echo "Bundler not installed"; exit 1; }

   # Check .env exists
   if [ ! -f .env ]; then
     echo "Error: .env file not found"
     echo "Copy .env.default to .env and fill in your values"
     exit 1
   fi

   # Interactive menu
   echo "Select deployment type:"
   echo "1) TestFlight (beta)"
   echo "2) App Store (release)"
   read -p "Choice: " choice

   case $choice in
     1) bundle exec fastlane beta ;;
     2) bundle exec fastlane release ;;
     *) echo "Invalid choice"; exit 1 ;;
   esac
   ```

2. **Create quick-test.sh script** (in PROJECT_ROOT)
   - Auto-navigates to PROJECT_ROOT
   - Runs test lane quickly
   - Good for local development verification

3. **Create update-metadata.sh script** (in PROJECT_ROOT)
   - Auto-navigates to PROJECT_ROOT
   - Helper for updating App Store metadata
   - Easier than remembering Fastlane commands

4. **Make all scripts executable**
   ```bash
   chmod +x deploy.sh quick-test.sh update-metadata.sh
   ```

## Phase 6: Changelog management

**Create CHANGELOG.md in PROJECT_ROOT**

Follow Keep a Changelog format:
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Feature descriptions go here

### Changed
- Changes go here

### Fixed
- Bug fixes go here

## [1.0.0] - 2024-01-15

### Added
- Initial release
- Feature list

[Unreleased]: https://github.com/user/repo/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/user/repo/releases/tag/v1.0.0
```

## Phase 7: CI/CD integration (optional but recommended)

1. **Detect existing CI/CD**
   - Check for .github/workflows in repo root or PROJECT_ROOT
   - Check for .gitlab-ci.yml
   - Check for bitrise.yml
   - Check for .circleci/config.yml

2. **Create GitHub Actions workflow** (if .github exists)
   Place workflow in repo root .github/workflows/

   **testflight.yml**:
   ```yaml
   name: Deploy to TestFlight

   on:
     push:
       branches: [main]
       paths:
         - 'ios/**'  # Adjust path to PROJECT_ROOT
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
             working-directory: ./ios  # PROJECT_ROOT path

         - name: Create .env file
           working-directory: ./ios  # PROJECT_ROOT path
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
           working-directory: ./ios  # PROJECT_ROOT path
           run: |
             mkdir -p fastlane
             echo "${{ secrets.APP_STORE_CONNECT_API_KEY }}" > fastlane/app_store_connect_api_key.p8

         - name: Deploy to TestFlight
           working-directory: ./ios  # PROJECT_ROOT path
           run: bundle exec fastlane beta
   ```

   **Required GitHub Secrets** (add at repo level):
   - `FASTLANE_USER`: Apple ID email
   - `FASTLANE_TEAM_ID`: Team ID
   - `FASTLANE_ITC_TEAM_ID`: iTunes Connect team ID
   - `APP_STORE_CONNECT_API_KEY_ID`: API key ID
   - `APP_STORE_CONNECT_API_ISSUER_ID`: Issuer ID
   - `APP_STORE_CONNECT_API_KEY`: Contents of .p8 file (raw text)

## Phase 8: Documentation generation

Create **DEPLOY-STEPS.md in PROJECT_ROOT** with:

1. **Project structure section**
   - Clearly state if this is a monorepo
   - Show the directory structure
   - Explain where all files are located
   - Provide commands that work from both repo root and PROJECT_ROOT
   - Example:
     ```
     # From repo root:
     cd ios && ./deploy.sh

     # From PROJECT_ROOT (ios/):
     ./deploy.sh
     ```

2. **Prerequisites checklist**
   - Apple Developer account with Admin access
   - App registered in App Store Connect
   - Xcode installed with command line tools
   - Ruby 3.0+ installed
   - Bundler installed
   - Git repository initialized

3. **One-time setup section**
   Step-by-step instructions with exact commands:

   **3.1. Enable Xcode automatic code signing**
   - Open project in Xcode
   - Select target → Signing & Capabilities
   - Check "Automatically manage signing"
   - Select your team
   - Xcode will handle certificates and profiles automatically

   **3.2. Create App Store Connect API key**
   - Go to App Store Connect → Users and Access → Keys
   - Generate new key with "App Manager" role
   - Download .p8 file (ONLY available once!)
   - Save as `PROJECT_ROOT/fastlane/app_store_connect_api_key.p8`
   - Note Key ID and Issuer ID

   **3.3. Set up environment variables**
   ```bash
   cd PROJECT_ROOT
   cp .env.default .env
   # Edit .env with your values
   ```

   **3.4. Install Ruby dependencies**
   ```bash
   cd PROJECT_ROOT
   bundle install
   ```

   **3.5. Verify setup**
   ```bash
   cd PROJECT_ROOT
   bundle exec fastlane prep
   ```

4. **Regular deployment workflow**

   **Deploy to TestFlight:**
   ```bash
   cd PROJECT_ROOT
   ./deploy.sh  # Select option 1
   # OR
   bundle exec fastlane beta
   ```

   **Deploy to production:**
   ```bash
   cd PROJECT_ROOT
   ./deploy.sh  # Select option 2
   # OR
   bundle exec fastlane release
   ```

   **Bump version:**
   ```bash
   bundle exec fastlane bump_patch  # 1.0.0 → 1.0.1
   bundle exec fastlane bump_minor  # 1.0.0 → 1.1.0
   bundle exec fastlane bump_major  # 1.0.0 → 2.0.0
   ```

5. **Troubleshooting section**

   **Error: "cannot load such file -- abbrev"**
   - Cause: Ruby 3.4+ removed abbrev from default gems
   - Solution: Ensure Gemfile has `gem "abbrev"` and `gem "ostruct"`
   - Run: `bundle install`

   **Error: "Could not find Xcode project"**
   - Cause: Wrong directory or incorrect path
   - Solution: Ensure you're in PROJECT_ROOT when running Fastlane
   - Fastlane looks for projects in parent directory (../)

   **Error: "Apple Generic Versioning is not enabled"**
   - Cause: Using agvtool-based actions (increment_build_number, increment_version_number)
   - Solution: These actions are NOT used in this setup - we use plutil commands
   - If you see this error, check your Fastfile for agvtool actions

   **Error: "No signing certificate 'Mac Installer Distribution' found"**
   - Cause: Missing required certificate for macOS App Store
   - Solution: Create "Mac Installer Distribution" certificate in Apple Developer portal
   - macOS requires TWO certificates (Apple Distribution AND Mac Installer Distribution)

   **Error: "No profiles for 'com.company.app' were found"**
   - Cause: Automatic signing couldn't create provisioning profile
   - Solution: Ensure `-allowProvisioningUpdates` flag is in xcargs
   - Check that bundle identifier matches Apple Developer portal

   **Error: Fastlane hangs after upload**
   - Cause: Waiting for Apple's build processing (5-30 minutes)
   - Solution: Our setup uses `skip_waiting_for_build_processing: true`
   - Build will still process and appear in TestFlight within 10-15 minutes

   **Error: "Could not load .env file"**
   - Cause: .env file not found or Fastfile not loading dotenv
   - Solution: Ensure Fastfile has dotenv require at the top (before default_platform)
   - Check .env file exists in PROJECT_ROOT

   **Error: Wrong directory**
   - Symptom: "No such file or directory" errors
   - Solution: Always run Fastlane from PROJECT_ROOT, not fastlane/ directory
   - Use `cd PROJECT_ROOT && bundle exec fastlane lane_name`

6. **What was automated**
   - ✅ Build number incrementation (automatic on every build)
   - ✅ Version number bumping (semantic versioning)
   - ✅ Code signing (automatic via Xcode)
   - ✅ Provisioning profile management (automatic)
   - ✅ App archiving and export
   - ✅ TestFlight upload
   - ✅ App Store upload
   - ✅ Git tagging for releases
   - ✅ Changelog management
   - ✅ CI/CD integration (optional)

   **Time savings**: ~30-45 minutes per deployment reduced to ~5 minutes

7. **Maintenance section**
   - Update Fastlane: `bundle update fastlane`
   - Update all gems: `bundle update`
   - Renew certificates: Xcode handles automatically for solo developers
   - Check certificate expiration: `security find-identity -v -p codesigning`
   - Rotate API keys: Generate new key in App Store Connect, update .env and .p8 file

## Phase 9: Validation and testing

1. **Run validation checks**
   - Verify PROJECT_ROOT was identified correctly
   - Test that all scripts are executable
   - Verify Gemfile.lock was created in PROJECT_ROOT
   - Check that .gitignore is properly configured
   - Validate Fastfile syntax with `bundle exec fastlane lanes`
   - Ensure all placeholders in .env.default are documented
   - Test scripts from both repo root and PROJECT_ROOT
   - Verify dotenv is loaded in Fastfile
   - Check that plutil commands (not agvtool) are used for versioning

2. **Create validation checklist in DEPLOY-STEPS.md**
   Before first deployment:
   - [ ] Bundle identifier registered in Apple Developer portal
   - [ ] App created in App Store Connect
   - [ ] "Apple Distribution" certificate installed
   - [ ] "Mac Installer Distribution" certificate installed (macOS only)
   - [ ] App Store Connect API key created and .p8 file saved
   - [ ] .env file created with all values filled in
   - [ ] Xcode automatic signing enabled in project
   - [ ] bundle install completed successfully
   - [ ] bundle exec fastlane prep passes all checks
   - [ ] MARKETING_VERSION and CURRENT_PROJECT_VERSION set in Xcode project

## Critical requirements

- ALWAYS clearly identify PROJECT_ROOT at the start
- ALWAYS show full paths in documentation
- ALL automation must work regardless of current directory
- Every file must have clear comments explaining purpose
- Every script must have error handling
- Every script must validate it's in the correct directory
- Every environment variable must be documented
- Every manual step must be explained with "why"
- Use battle-tested best practices:
  - Never use agvtool - always use plutil commands
  - Always load dotenv explicitly in Fastfile
  - Always use skip_waiting_for_build_processing for uploads
  - Always use -allowProvisioningUpdates for automatic signing
  - Always include abbrev and ostruct gems for Ruby 3.4+
  - Always use File.expand_path for path resolution
  - Always use App Store Connect API keys (not Apple ID)
- Make it impossible for the user to skip critical steps
- Use semantic versioning strictly
- Include rollback instructions if something fails
- Make the deploy.sh output beautiful and confidence-inspiring

## Common errors and their solutions

### "cannot load such file -- abbrev"
**Solution:** Add to Gemfile: `gem "abbrev"` and `gem "ostruct"`

### "Could not find Xcode project"
**Solution:** Use relative paths with `../` prefix since Fastlane runs from fastlane/ directory

### "Apple Generic Versioning is not enabled"
**Solution:** Don't use agvtool actions. Use plutil commands directly.

### "No signing certificate found"
**Solution:** For macOS, create "Mac Installer Distribution" certificate in Apple Developer portal

### "No profiles found"
**Solution:** Add `-allowProvisioningUpdates` to xcargs for automatic provisioning profile creation

### Long wait after upload
**Solution:** Use `skip_waiting_for_build_processing: true` and `skip_submission: true`

### Environment variables not loading
**Solution:** Add dotenv require at top of Fastfile with proper path resolution

## Output format

1. First, show PROJECT_ROOT discovery results with full path
2. If multiple projects found, ask which one to configure
3. Show project structure (monorepo or standalone)
4. Show your execution plan before implementing
5. Implement all files and scripts (with correct paths)
6. Generate the comprehensive DEPLOY-STEPS.md
7. End with a summary including exact commands to run next

## Quality standards

This is production infrastructure. Every command must be correct. Every path must be accurate. Every instruction must work from any starting directory. Test automation yourself before documenting. If you're unsure about a step, research it or ask for clarification rather than guessing.
