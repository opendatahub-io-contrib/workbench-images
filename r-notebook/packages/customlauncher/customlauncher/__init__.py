"""
See https://jupyter-server-proxy.readthedocs.io/en/latest/server-process.html
for more information.
"""
import getpass
import os
import pathlib
import shutil
import subprocess
import tempfile
from textwrap import dedent

def get_rstudio_executable(prog):
    # Find prog in known locations
    other_paths = [
        # When rstudio-server deb is installed
        os.path.join('/usr/lib/rstudio-server/bin', prog),
        # When just rstudio deb is installed
        os.path.join('/usr/lib/rstudio/bin', prog),
    ]
    if shutil.which(prog):
        return prog

    for op in other_paths:
        if os.path.exists(op):
            return op

    raise FileNotFoundError(f'Could not find {prog} in PATH')

def get_icon_path():
    return os.path.join(
        os.path.dirname(os.path.abspath(__file__)), 'icons', 'rstudio.svg'
    )

def setup_rstudio():
    def _rstudio_command(port):
        working_dir = os.getenv("RSTUDIO_WORKINGDIR", None)
        if working_dir is None:
            working_dir = os.getenv("JUPYTER_SERVER_ROOT", ".")

        return ['/usr/lib/rstudio-server/bin/rserver',
            f'--www-port={port}',
            "--auth-none=1",
            "--www-frame-origin=same",
            "--www-address=127.0.0.1",
            "--server-data-dir=/opt/app-root/rstudio-server",
            "--server-daemonize=0",
            "--server-user=rstudio-server",
            f"--server-working-dir={working_dir}"
        ]

    return {
        'command': _rstudio_command,
        'timeout': 30,
        'launcher_entry': {
            'title': 'RStudio',
            'icon_path': os.path.join(os.path.dirname(os.path.abspath(__file__)), 'icons', 'rstudio.svg'),
            'enabled': True
        }
    }