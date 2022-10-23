import getpass
import os
import pathlib
import shutil
import subprocess
import tempfile
from textwrap import dedent
from urllib.parse import urlparse, urlunparse

def setup_vscode():
    def _vscode_command(port):
        working_dir = os.getenv("CODE_WORKINGDIR", None)
        if working_dir is None:
            working_dir = os.getenv("JUPYTER_SERVER_ROOT", ".")

        return ['code-server',
            f'--port={port}',
            "--auth=none",
            "--disable-telemetry",
            "--disable-update-check",
            "--host=127.0.0.1",
            working_dir ]

    return {
        'command': _vscode_command,
        'timeout': 30,
        'launcher_entry': {
            'title': 'VS Code',
            'icon_path': os.path.join(os.path.dirname(os.path.abspath(__file__)), 'icons', 'vscode.svg'),
            'enabled': True
        }
    }
