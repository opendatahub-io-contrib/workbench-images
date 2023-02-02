import getpass
import os
import shutil
import subprocess
import tempfile
from textwrap import dedent
from urllib.parse import urlparse, urlunparse

def get_rstudio_executable(prog):
    # Find prog in known locations
    other_paths = [
        # When rstudio-server deb is installed
        os.path.join('/usr/lib/rstudio-server/bin', prog),
        # When just rstudio deb is installed
        os.path.join('/usr/lib/rstudio/bin', prog),
    ]
    if shutil.which(prog):
        return shutil.which(prog)

    for op in other_paths:
        if os.path.exists(op):
            return op

    raise FileNotFoundError(f'Could not find {prog} in PATH')

def db_config(db_dir):
    '''
    Create a temporary directory to hold rserver's database, and create
    the configuration file rserver uses to find the database.

    https://docs.rstudio.com/ide/server-pro/latest/database.html
    https://github.com/rstudio/rstudio/tree/v1.4.1103/src/cpp/server/db
    '''
    # create the rserver database config
    db_conf = dedent("""
        provider=sqlite
        directory={directory}
    """).format(directory=db_dir)
    f = tempfile.NamedTemporaryFile(mode='w', delete=False, dir=db_dir)
    db_config_name = f.name
    f.write(db_conf)
    f.close()
    return db_config_name

def _support_arg(arg):
    ret = subprocess.check_output([get_rstudio_executable('rserver'), '--help'])
    return ret.decode().find(arg) != -1

def _get_cmd(port):
    ntf = tempfile.NamedTemporaryFile()

    # use mkdtemp() so the directory and its contents don't vanish when
    # we're out of scope
    server_data_dir = tempfile.mkdtemp()
    database_config_file = db_config(server_data_dir)

    cmd = [
        get_rstudio_executable('rserver'),
        '--server-daemonize=0',
        '--server-working-dir=' + os.getenv('HOME'),
        '--auth-none=1',
        '--www-frame-origin=same',
        #'--www-address=0.0.0.0',
        '--www-port=' + str(port),
        '--www-verify-user-agent=0',
        '--rsession-which-r=' + get_rstudio_executable('R'),
        '--secure-cookie-key-file=' + ntf.name,
        '--server-user=' + getpass.getuser(),
        '--rsession-path=/opt/app-root/bin/rsession.sh',
    ]
    # Support at least v1.2.1335 and up

    #if _support_arg('www-root-path'):
    #    cmd.append('--www-root-path=/rstudio/')
    if _support_arg('server-data-dir'):
        cmd.append(f'--server-data-dir={server_data_dir}')
    if _support_arg('database-config-file'):
        cmd.append(f'--database-config-file={database_config_file}')
    
    return(' '.join(cmd))

if __name__ == "__main__":
    print(_get_cmd(8787))
