"""Check the fresh-Mac setup contract without installing tools or touching projects."""
import os
import tempfile
import pathlib
import subprocess
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class SetupContract(unittest.TestCase):
    def test_project_plan_contains_all_apps_and_release_tool(self):
        result = subprocess.run(['bash', str(ROOT / 'prepare-projects.sh'), '--plan'], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        for repo in ['futurenerds', 'tripmaster', 'mail-notifier', 'meeting-notifier', 'ship']:
            self.assertIn('CoolAssPuppy/' + repo, result.stdout)
        self.assertIn('No repositories or services changed', result.stdout)

    def test_mobile_plan_does_not_accept_licenses_or_start_devices(self):
        result = subprocess.run(['bash', str(ROOT / 'setup-mobile.sh'), '--plan'], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('platforms;android-37', result.stdout)
        self.assertIn('platforms;android-36', result.stdout)
        self.assertIn('interactive', result.stdout)

    def test_mobile_setup_creates_device_using_installed_sdk_tools(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            binaries = root / 'bin'
            binaries.mkdir()
            commands = {
                'xcodebuild': 'exit 0',
                'brew': 'echo /unused/java',
                'xcrun': 'echo "iOS 27 com.apple.CoreSimulator"',
                'avdmanager': 'echo "wrong SDK root" >&2; exit 1',
                'sdkmanager': """case "$*" in
  *'cmdline-tools;latest'*)
    mkdir -p "$ANDROID_HOME/cmdline-tools/latest/bin"
    cat > "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" <<'AVD'
#!/bin/bash
case "$1" in
  list) exit 0 ;;
  create) touch "$ANDROID_HOME/device-created" ;;
esac
AVD
    chmod +x "$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager" ;;
esac""",
            }
            for name, body in commands.items():
                command = binaries / name
                command.write_text('#!/bin/bash\n' + body + '\n')
                command.chmod(0o755)
            environment = dict(os.environ, PATH=str(binaries) + ':/usr/bin:/bin',
                               ANDROID_HOME=str(root / 'sdk'))
            result = subprocess.run(['bash', str(ROOT / 'setup-mobile.sh')],
                                    env=environment, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue((root / 'sdk/device-created').is_file())

    def test_unknown_setup_option_fails_without_installing(self):
        for name in ['prepare-projects.sh', 'setup-mobile.sh']:
            result = subprocess.run(['bash', str(ROOT / name), '--unknown'], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)


if __name__ == '__main__':
    unittest.main()
