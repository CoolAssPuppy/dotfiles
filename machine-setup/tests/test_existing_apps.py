"""The bootstrap must preserve an installed app used for remote access."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class ExistingApps(unittest.TestCase):
    def test_manually_installed_app_is_not_reinstalled(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ['brew-sync.sh', 'lib.sh']:
                shutil.copyfile(ROOT / name, root / name)
            (root / 'Brewfile').write_text('cask "existing-app"\n')
            brew = root / 'brew'
            brew.write_text('''#!/bin/bash
case "$*" in
  update) exit 0 ;;
  "trust --help") exit 1 ;;
  "list --formula -1"|"list --cask -1"|"outdated --quiet") exit 0 ;;
  "info --json=v2 --cask existing-app")
    echo '{"casks":[{"artifacts":[{"app":["Utilities"]}]}]}' ;;
  *) echo "Unexpected brew command: $*" >&2; exit 99 ;;
esac
''')
            brew.chmod(0o755)
            env = {**os.environ, 'PATH': str(root) + ':/usr/bin:/bin:/usr/sbin:/sbin'}
            result = subprocess.run(['bash', str(root / 'brew-sync.sh')], env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn('Preserve existing existing-app', result.stdout)


if __name__ == '__main__':
    unittest.main()
