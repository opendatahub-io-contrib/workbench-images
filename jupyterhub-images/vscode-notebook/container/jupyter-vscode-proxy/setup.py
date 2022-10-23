import setuptools

setuptools.setup(
    name="jupyter-vscode-proxy",
    version='0.0.1',
    url="https://github.com/guimou",
    author="Guillaume Moutier",
    description="Jupyter extension to proxy VS Code (Code Server)",
    packages=setuptools.find_packages(),
	keywords=['Jupyter'],
	classifiers=['Framework :: Jupyter'],
    install_requires=[
        'jupyter-server-proxy>=3.2.0'
    ],
    entry_points={
        'jupyter_serverproxy_servers': [
            'vscode = jupyter_vscode_proxy:setup_vscode'
        ]
    },
    package_data={
        'jupyter_vscode_proxy': ['icons/vscode.svg'],
    },
)
