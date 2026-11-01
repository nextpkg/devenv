"""Isolated installer tests; never run package installation or write real HOME."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

VIM_DIR = Path(__file__).resolve().parents[1] / 'vim'
SOURCE = (VIM_DIR / 'install.sh').read_text()


def function(name):
    return name + '() {' + SOURCE.split(name + '() {', 1)[1].split('\n}', 1)[0] + '\n}'


class VimInstallerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='vim-installer-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.settings = self.root / 'user settings'
        self.settings.mkdir()
        (self.settings / '.vimrc').write_text('original settings\n')

    def run_install(self, vim_status=0, clone_status=0):
        # Run the installation phase with test-only command substitutes.
        script = ('set -e\n' + function('backup_file')
                  + f'\ngit() {{ return {clone_status}; }}\n'
                  + f'vim() {{ return {vim_status}; }}\n'
                  + SOURCE.split('## -------------------- PROCESS --------------------', 1)[1])
        env = os.environ.copy()
        env.update(AUDIT_HOME=str(self.settings), SCRIPT_DIR=str(VIM_DIR))
        return subprocess.run(['bash', '-c', script.replace('$HOME', '$AUDIT_HOME')],
                              env=env, capture_output=True, text=True)

    def test_failed_clone_preserves_active_config(self):
        result = self.run_install(clone_status=42)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.settings / '.vimrc').read_text(), 'original settings\n')
        self.assertEqual(list(self.settings.glob('.vimrc.bak.*')), [])

    def test_failed_plugins_preserve_config_and_custom_plugin(self):
        plugin = self.settings / '.vim/bundle/personal/plugin.vim'
        plugin.parent.mkdir(parents=True)
        plugin.write_text('user work')
        result = self.run_install(vim_status=1)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.settings / '.vimrc').read_text(), 'original settings\n')
        self.assertEqual(plugin.read_text(), 'user work')

    def test_success_backs_up_old_config_and_removes_staging_file(self):
        result = self.run_install()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.settings / '.vimrc').read_bytes(), (VIM_DIR / '.vimrc').read_bytes())
        backups = list(self.settings.glob('.vimrc.bak.*'))
        self.assertEqual(len(backups), 1)
        self.assertEqual(backups[0].read_text(), 'original settings\n')
        self.assertEqual(list(self.settings.glob('.vimrc.new.*')), [])

    def test_bsd_ctags_rejected_and_compatible_alternative_accepted(self):
        # Override command resolution so host Homebrew installations cannot affect the test.
        script = function('find_compatible_ctags') + '''
ctags() { echo 'BSD ctags'; return 1; }
ctags-exuberant() { echo 'Exuberant Ctags 5.8'; }
find_compatible_ctags
'''
        result = subprocess.run(['bash', '-c', script], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        script = function('find_compatible_ctags') + '''
ctags() { echo 'BSD ctags'; return 1; }
ctags-exuberant() { return 1; }
exuberant-ctags() { return 1; }
universal-ctags() { return 1; }
/opt/homebrew/bin/ctags() { return 1; }
/usr/local/bin/ctags() { return 1; }
/opt/homebrew/opt/universal-ctags/bin/ctags() { return 1; }
/usr/local/opt/universal-ctags/bin/ctags() { return 1; }
find_compatible_ctags
'''
        result = subprocess.run(['bash', '-c', script], capture_output=True, text=True)
        self.assertEqual(result.returncode, 1, result.stderr)

    def test_generator_matches_checked_in_files(self):
        target = self.root / 'vim'
        shutil.copytree(VIM_DIR, target)
        subprocess.run(['python3', '-B', str(target / 'build.py')], check=True)
        for name in ('install.sh', '.vimrc', '.vimrc.bundle'):
            self.assertEqual((target / name).read_bytes(), (VIM_DIR / name).read_bytes(), name)


if __name__ == '__main__':
    unittest.main()
