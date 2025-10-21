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
   - Identify all targets and schemes
   - Extract bundle identifier(s), team ID, and app name
   - Check current version and build numbers
   - Identify any app extensions, widgets, or additional targets
   - Check for existing CI/CD configuration

4. **Environment audit**
   - Check if Xcode Command Line Tools are installed
   - Verify Ruby version (2.7+ recommended)
   - Check if Bundler is available
   - Look for existing Fastlane installation in PROJECT_ROOT
   - Check for existing certificates in keychain
   - Verify git is configured with user info

## Phase 2: Fastlane installation and configuration

**CRITICAL: All Fastlane files go in PROJECT_ROOT, not repo root**

1. **Install dependencies**
   - Create `Gemfile` in PROJECT_ROOT with Fastlane and necessary plugins:
     - fastlane-plugin-increment_build_number
     - fastlane-plugin-versioning (for iOS)
     - fastlane-plugin-changelog
   - Run `bundle install` from PROJECT_ROOT to create Gemfile.lock
   - Initialize Fastlane with `bundle exec fastlane init` from PROJECT_ROOT

2. **Configure Appfile** (in PROJECT_ROOT/fastlane/)
   - Set app_identifier (or multiple for multi-target apps)
   - Set apple_id placeholder (user will provide)
   - Set team_id placeholder (user will provide)
   - Set itc_team_id if different from team_id

3. **Create comprehensive Fastfile** (in PROJECT_ROOT/fastlane/)
   Build these lanes:
   
   **prep lane**: Pre-flight checks
   - Verify environment variables are set
   - Check certificates are available
   - Validate provisioning profiles
   - Ensure git working directory is clean (check repo root)
   - Check that version numbers follow semantic versioning
   - Verify we're in the correct directory (PROJECT_ROOT)
   
   **test lane**: Run all tests
   - Run unit tests for all schemes
   - Run UI tests if they exist
   - Generate test report
   - Fail fast if any tests fail
   
   **bump_patch/bump_minor/bump_major lanes**: Version management
   - Increment version number according to semantic versioning
   - Increment build number automatically
   - Commit version bump to git (from repo root if monorepo)
   - Create git tag
   
   **screenshots lane**: Generate App Store screenshots
   - Use Snapshot if UI tests exist
   - Frame screenshots with device frames
   - Generate for all required device sizes
   - Organize by locale
   
   **beta lane**: TestFlight deployment
   - Run tests first
   - Build app with archive
   - Export IPA with App Store provisioning
   - Upload to TestFlight
   - Skip waiting for build processing by default
   - Send notification on completion
   
   **release lane**: Production App Store deployment
   - Prompt for confirmation (safety check)
   - Run tests first
   - Build and archive
   - Export IPA
   - Upload to App Store Connect
   - Submit for review (optional flag)
   - Generate release notes from changelog
   
   **metadata lane**: Update App Store metadata
   - Update descriptions, keywords, screenshots
   - Handle multiple localizations if present
   - Upload promotional artwork
   
   **download_metadata lane**: Pull current App Store metadata
   - Useful for initial setup or syncing changes

## Phase 3: Code signing setup

1. **Determine code signing strategy**
   - Check if using Xcode automatic signing or manual
   - Recommend using fastlane match for team environments
   - Set up match if chosen, otherwise configure cert/sigh

2. **Configure match (recommended)** (in PROJECT_ROOT/fastlane/)
   - Initialize match with `bundle exec fastlane match init`
   - Create Matchfile with git repo URL placeholder
   - Document the git repo requirement
   - Create match lanes for development, adhoc, and appstore profiles
   - Add match to .gitignore

3. **Alternative: cert and sigh**
   - Configure cert to manage certificates
   - Configure sigh to manage provisioning profiles
   - Document manual certificate management

## Phase 4: Environment and secrets management

**Place .env files in PROJECT_ROOT, not repo root**

1. **Create .env files** (in PROJECT_ROOT)
   - `.env.default`: Template with all required variables (checked into git)
   - `.env`: Actual secrets (gitignored)
   
   Required variables:
   - FASTLANE_USER (Apple ID)
   - FASTLANE_TEAM_ID
   - FASTLANE_ITC_TEAM_ID (if different)
   - MATCH_PASSWORD (if using match)
   - MATCH_GIT_URL (if using match)
   - FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
   - APP_STORE_CONNECT_API_KEY_ID (recommended over password)
   - APP_STORE_CONNECT_API_ISSUER_ID
   - APP_STORE_CONNECT_API_KEY_PATH
   
2. **Update .gitignore** (add to existing repo .gitignore or create in PROJECT_ROOT)
   - Use relative paths from repo root if monorepo
   - Add .env
   - Add fastlane/report.xml (adjust path if needed)
   - Add fastlane/Preview.html
   - Add fastlane/screenshots (if not committing)
   - Add fastlane/test_output
   - Add *.ipa, *.dSYM.zip
   - Add certificates and profiles if not using match

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

2. **Create quick-test.sh script** (in PROJECT_ROOT)
   - Auto-navigates to PROJECT_ROOT
   - Runs test lane quickly
   - Good for local development verification

3. **Create update-metadata.sh script** (in PROJECT_ROOT)
   - Auto-navigates to PROJECT_ROOT
   - Helper for updating App Store metadata
   - Easier than remembering Fastlane commands

4. **Make all scripts executable**
   - chmod +x for all .sh files

## Phase 6: Changelog management

**Create CHANGELOG.md in PROJECT_ROOT**

1. **Create CHANGELOG.md**
   - Follow Keep a Changelog format
   - Include Unreleased section
   - Create initial version entry
   - Make it clear this is for the iOS/macOS app specifically

2. **Create changelog automation**
   - Script or lane to extract version entries
   - Convert markdown to App Store-friendly format
   - Support multiple locales if needed

## Phase 7: CI/CD integration (optional but recommended)

1. **Detect existing CI/CD**
   - Check for .github/workflows in repo root or PROJECT_ROOT
   - Check for .gitlab-ci.yml
   - Check for bitrise.yml
   - Check for .circleci/config.yml

2. **Create GitHub Actions workflow** (if .github exists)
   - Place workflow in repo root .github/workflows/
   - Workflow must cd to PROJECT_ROOT before running Fastlane
   - Workflow for running tests on PR
   - Workflow for deploying to TestFlight on merge to main
   - Workflow for deploying to production on release tag
   - Include secrets documentation
   - Use working-directory parameter or explicit cd commands
   - Example:
     ```yaml
     - name: Deploy to TestFlight
       working-directory: ./ios  # or whatever PROJECT_ROOT is
       run: bundle exec fastlane beta
     ```

3. **Document CI/CD setup**
   - What secrets need to be added (repo level, not project level)
   - How to trigger workflows
   - How to view results
   - Note the monorepo structure in docs

## Phase 8: Documentation generation

After completing all setup, create **DEPLOY-STEPS.md in PROJECT_ROOT** with:

1. **Project structure section** (NEW)
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

2. **Prerequisites checklist section**
   - What the user needs from Apple Developer account
   - What the user needs from App Store Connect
   - Required access levels

3. **One-time setup section**
   - Step-by-step instructions for:
     - Creating App Store Connect app entry (if not exists)
     - Generating App Store Connect API key
     - Setting up certificates (if not using match)
     - Configuring match git repository (if using match)
     - Adding secrets to .env file (note exact path)
     - Running initial setup commands
   - Each step numbered with exact commands to run
   - Each command shows full path (cd ios && bundle install)
   - Each step explains why it's necessary

4. **Regular deployment workflow section**
   - How to deploy to TestFlight
   - How to deploy to production
   - How to update metadata
   - How to generate screenshots
   - Example commands for each scenario
   - Commands work from repo root AND PROJECT_ROOT

5. **Troubleshooting section**
   - Common errors and solutions
   - Wrong directory errors
   - How to regenerate certificates
   - How to fix code signing issues
   - Where to find logs (note full paths)

6. **What was automated section**
   - Clear list of everything now automated
   - Time savings estimate
   - Comparison to manual process

7. **Maintenance section**
   - How to update Fastlane
   - How to update certificates before expiry
   - How to add new team members

## Phase 9: Validation and testing

1. **Run validation checks**
   - Verify PROJECT_ROOT was identified correctly
   - Test that all scripts are executable
   - Verify Gemfile.lock was created in PROJECT_ROOT
   - Check that .gitignore is properly configured
   - Validate Fastfile syntax
   - Ensure all placeholders are documented
   - Test scripts from both repo root and PROJECT_ROOT

2. **Create validation checklist in DEPLOY-STEPS.md**
   - Things user must verify before first deployment
   - How to test without actually submitting
   - Verify correct directory is being used

## Critical requirements

- ALWAYS clearly identify PROJECT_ROOT at the start
- ALWAYS show full paths in documentation
- ALL automation must work regardless of current directory
- Every file must have clear comments explaining purpose
- Every script must have error handling
- Every script must validate it's in the correct directory
- Every environment variable must be documented
- Every manual step must be explained with "why"
- Use best practices from official Fastlane documentation
- Optimize for the 80/20 rule: automate common tasks perfectly
- Make it impossible for the user to skip critical steps
- Use semantic versioning strictly
- Include rollback instructions if something fails
- Make the deploy.sh output beautiful and confidence-inspiring

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

$ARGUMENTS