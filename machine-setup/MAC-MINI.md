# Mac mini development setup

This prepares FutureNerds and TripMaster for web, iOS, and Android work, and Mail Notifier and Meeting Notifier for macOS work. It does not migrate running services, start databases, run application tests, or publish a release.

## First setup

Create the macOS user with short name `prashant`. Install the latest full Xcode from the App Store, open it, complete its first-launch setup, and install the iOS platform and a simulator runtime in Xcode Settings. The Command Line Tools alone cannot build the apps.

Enable Screen Sharing and Remote Login in System Settings, General, Sharing, restricted to your account. Install Tailscale, sign in to the existing household tailnet, and approve the new device. Verify access from the MacBook Air before removing the display.

Install Homebrew using the command published at [Homebrew](https://brew.sh). Install the Command Line Tools if prompted, wait for completion, then open a new terminal. On Apple silicon:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install gh
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
mkdir -p ~/Developer
gh repo clone CoolAssPuppy/dotfiles ~/Developer/dotfiles
gh repo clone CoolAssPuppy/brain ~/Developer/brain
cd ~/Developer/dotfiles
./machine-setup/dev-install.sh
```

The installer adds shell/editor configuration, the shared Claude/Codex configuration, Node 24, pnpm 11.1.0, Java 21, Android Studio and command-line tools, XcodeGen, SwiftLint, Python/uv, Doppler, GitHub, and the existing Brewfile tools. It backs up replaced dotfiles. Browser/AI application sign-ins are separate from linking their configuration.

## Native SDKs

Select full Xcode after installing it. Open it to accept the license and install components; do not automatically accept licenses in a background script.

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
cd ~/Developer/dotfiles
./machine-setup/setup-mobile.sh
```

This asks you to review Android licenses, then installs Android 36 and 37.0 platforms, build tools 36/37, platform tools, emulator, and an ARM64 Android 36 Google APIs image. Google publishes the API 37 platform as `platforms;android-37.0`, not `platforms;android-37`. It creates `Dev_Phone_API_36` without starting it. It reports a missing iOS runtime instead of claiming native setup is complete.

Open a new terminal to pick up Java and Android paths. Full Xcode is installed manually; Homebrew does not install it here. An iOS runtime download may take substantial disk space and time.

## Accounts and repositories

```bash
doppler login
cd ~/Developer/dotfiles
./machine-setup/prepare-projects.sh
```

The project script clones missing repositories under `~/Developer`, installs Node dependencies from frozen lockfiles, and installs the editable `ship` CLI from `~/Developer/utils/ship`. It leaves existing branch state intact and stops for dirty repositories or an unexpected origin. It does not run git pull against existing work.

Configure the existing Doppler development projects within the respective repositories:

```bash
cd ~/Developer/futurenerds && doppler setup --project futurenerds --config dev
cd ~/Developer/tripmaster && doppler setup --project tripmaster --config dev
cd ~/Developer/mail-notifier && doppler setup --project mail-notifier --config dev
cd ~/Developer/meeting-notifier && doppler setup --project meeting-notifier --config dev
```

Release configuration remains project-specific. The existing `mobile-release` project is available too; inspect each repository's release scripts before choosing its release configuration. Do not copy secret values into the dotfiles repository.

The Brewfile installs the Codex and Claude Code CLIs and Cursor. Authenticate each client with its subscription account. Install the ChatGPT desktop app separately if you want its graphical and remote-control features. Subscription sessions are machine-specific. Sign in to Xcode's Apple account and import the existing signing identities, with private keys, through Keychain Access. Doppler API keys alone do not replace every code-signing certificate or provisioning requirement. Keep certificate transfers encrypted and out of Git.

## Project verification

- FutureNerds: read its current `AGENTS.md`, use its pinned local Supabase CLI and documented native `pnpm run db:start`, then `pnpm run hooks:install` and `pnpm check`. Use its `pnpm suite` entry point for requested test selections. Do not run the entire gate as an installation side effect.
- TripMaster: follow its current setup and test instructions. Its local backend may conflict with another project's database ports; run one conflicting stack at a time until isolated.
- Mail Notifier: XcodeGen source is root `project.yml`. Use its checked-in build and release instructions.
- Meeting Notifier: the native project is under `MeetingNotifier/`, with its `project.yml` there. Use that directory for native project commands.
- `ship doctor` is a read-only readiness check when the project has `ship.toml`. Do not run `ship init` merely to configure this machine; it can create project and service configuration.

Once the tools and accounts are ready, verify a development build and selected tests for each app. Until those pass on the mini, this document proves setup coverage rather than successful application builds.

## Installer checks

```bash
python3 -m unittest discover -s machine-setup/tests -v
./machine-setup/setup-mobile.sh --plan
./machine-setup/prepare-projects.sh --plan
```
