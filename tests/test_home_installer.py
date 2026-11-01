"""Exercise installer functions without installing packages or changing user settings."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SOURCE_DIR = Path(__file__).resolve().parents[1] / "home"
SOURCE = (SOURCE_DIR / "install.sh").read_text()
FUNCTIONS = "\n".join(
    name + "() {" + SOURCE.split(name + "() {", 1)[1].split("\n}", 1)[0] + "\n}"
    for name in ("backup_file", "install_config", "setup_zsh")
)


class HomeInstallerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="devenv-test-")
        self.addCleanup(self.temp.cleanup)
        self.zsh = Path(self.temp.name) / "oh my zsh"
        self.custom = self.zsh / "custom"

    def run_setup(self, curl_body="return 22"):
        env = os.environ.copy()
        env.update(ZSH=str(self.zsh), ZSH_CUSTOM=str(self.custom),
                   SCRIPT_DIR=str(SOURCE_DIR))
        return subprocess.run(
            ["bash", "-e", "-c", FUNCTIONS + "\ncurl() { " + curl_body
             + "; }\nsetup_zsh"],
            env=env, capture_output=True, text=True,
        )

    def test_existing_configs_backed_up_and_repeat_is_idempotent(self):
        self.custom.mkdir(parents=True)
        (self.zsh / "oh-my-zsh.sh").touch()
        for name in ("alias.zsh", "config.zsh"):
            (self.custom / name).write_text("original " + name)
        for _ in range(2):
            result = self.run_setup()
            self.assertEqual(result.returncode, 0, result.stderr)
        for name in ("alias.zsh", "config.zsh"):
            self.assertEqual((self.custom / name).read_bytes(),
                             (SOURCE_DIR / name).read_bytes())
            backups = list(self.custom.glob(name + ".bak.*"))
            self.assertEqual(len(backups), 1)
            self.assertEqual(backups[0].read_text(), "original " + name)

    def test_download_failure_leaves_no_directory_and_retry_succeeds(self):
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.zsh.exists())
        result = self.run_setup(
            "printf '%s\\n' 'mkdir -p \"$ZSH\"' ': > \"$ZSH/oh-my-zsh.sh\"'"
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue((self.zsh / "oh-my-zsh.sh").is_file())
        self.assertEqual((self.custom / "alias.zsh").read_bytes(),
                         (SOURCE_DIR / "alias.zsh").read_bytes())

    def test_success_without_entry_file_is_rejected(self):
        result = self.run_setup("printf '%s\\n' ':'")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.custom.exists())

    def test_installer_failure_stops_before_custom_configs(self):
        result = self.run_setup("printf '%s\\n' 'exit 7'")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.custom.exists())

    def test_existing_incomplete_install_is_preserved(self):
        self.zsh.mkdir()
        marker = self.zsh / "user-file"
        marker.write_text("preserve")
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(marker.read_text(), "preserve")
        self.assertFalse(self.custom.exists())


if __name__ == "__main__":
    unittest.main()
