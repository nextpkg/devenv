"""Run offline against a supplied Vundle checkout: python3 -B tests/vim_vundle_integration.py PATH."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

vundle = Path(sys.argv[1]).resolve()
assert (vundle / 'autoload/vundle.vim').is_file()
vim_dir = Path(__file__).resolve().parents[1] / 'vim'
git = shutil.which('git')


def quote(value):
    return "'" + str(value).replace("'", "''") + "'"


with tempfile.TemporaryDirectory(prefix='vim-vundle-') as directory:
    root = Path(directory)
    seed = root / 'seed'
    seed.mkdir()
    subprocess.run([git, 'init', '-q', str(seed)], check=True)
    (seed / 'plugin').mkdir()
    (seed / 'plugin/demo.vim').write_text('let g:demo_loaded = 1\n')
    subprocess.run([git, '-C', str(seed), 'add', '.'], check=True)
    # Identity is limited to this fixture command, never stored in Git configuration.
    subprocess.run([git, '-C', str(seed), '-c', 'user.name=Test Fixture', '-c',
                    'user.email=fixture@example.invalid', 'commit', '-qm', 'fixture'], check=True)
    binaries = root / 'bin'
    binaries.mkdir()
    wrapper = binaries / 'git'
    wrapper.write_text('#!' + sys.executable + '\n' + '''import os,sys,subprocess
if sys.argv[1] == 'clone':
    if os.environ.get('FAIL_CLONE') == '1':
        sys.exit(42)
    subprocess.run([os.environ['REAL_GIT'], 'clone', os.environ['SEED'], sys.argv[-1]], check=True)
    subprocess.run([os.environ['REAL_GIT'], '-C', sys.argv[-1], 'remote', 'set-url', 'origin', sys.argv[-2]], check=True)
    sys.exit(0)
os.execv(os.environ['REAL_GIT'], ['git'] + sys.argv[1:])
''')
    wrapper.chmod(0o755)
    bundles = root / 'bundles'
    personal = bundles / 'personal-plugin/work.txt'
    personal.parent.mkdir(parents=True)
    personal.write_text('uncommitted work')
    config = root / 'bundle.vim'
    config.write_text('set nocompatible\nexecute "set rtp+=" . fnameescape(' + quote(vundle)
                      + ')\ncall vundle#begin(' + quote(bundles)
                      + ")\nPlugin 'audit/demo'\ncall vundle#end()\n")
    env = os.environ.copy()
    env.update(PATH=str(binaries) + os.pathsep + env['PATH'], REAL_GIT=git,
               SEED=str(seed), FAIL_CLONE='1')
    command = ['vim', '-N', '-n', '-i', 'NONE', '-es', '-u', str(config), '-S',
               str(vim_dir / 'install-plugins.vim')]
    failed = subprocess.run(command, env=env, capture_output=True, timeout=30)
    assert failed.returncode != 0, 'Plugin failure was swallowed'
    assert personal.read_text() == 'uncommitted work'
    env['FAIL_CLONE'] = '0'
    success = subprocess.run(command, env=env, capture_output=True, timeout=30)
    assert success.returncode == 0, success.stderr
    assert (bundles / 'demo/plugin/demo.vim').is_file()
    assert personal.read_text() == 'uncommitted work'
    # Existing user modifications must not be reset or pulled on a repeat install.
    (bundles / 'demo/plugin/demo.vim').write_text('" user modification')
    repeat = subprocess.run(command, env=env, capture_output=True, timeout=30)
    assert repeat.returncode == 0, repeat.stderr
    assert (bundles / 'demo/plugin/demo.vim').read_text() == '" user modification'
    print(json.dumps({'failed_clone_exit': failed.returncode,
                      'retry_exit': success.returncode, 'repeat_exit': repeat.returncode,
                      'custom_plugin_preserved': True, 'local_modifications_preserved': True}))
