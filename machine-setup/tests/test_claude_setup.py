"""Claude configuration must install into a new user's home directory."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[2] / 'claude/setup.sh'


class ClaudeSetup(unittest.TestCase):
    def test_fresh_home_and_repeat_install(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / 'dotfiles/claude'
            source.mkdir(parents=True)
            shutil.copyfile(SCRIPT, source / 'setup.sh')
            for name in ['agents', 'commands', 'docs', 'rules']:
                (source / name).mkdir()
            (source / 'CLAUDE.md').write_text('Fixture instructions.\n')
            home = root / 'home'
            home.mkdir()
            env = {**os.environ, 'HOME': str(home), 'BRAIN': str(root / 'no-brain')}
            for _ in range(2):
                result = subprocess.run(['bash', str(source / 'setup.sh')], env=env, capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertEqual((home / '.claude/CLAUDE.md').read_text(), 'Fixture instructions.\n')


if __name__ == '__main__':
    unittest.main()
