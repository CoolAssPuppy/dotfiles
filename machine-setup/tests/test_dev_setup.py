"""Check the fresh-Mac setup contract without installing tools or touching projects."""
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

    def test_unknown_setup_option_fails_without_installing(self):
        for name in ['prepare-projects.sh', 'setup-mobile.sh']:
            result = subprocess.run(['bash', str(ROOT / name), '--unknown'], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)


if __name__ == '__main__':
    unittest.main()
