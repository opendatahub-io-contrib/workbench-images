# Streamlit extension for JupyterLab

Adds a Streamlit menu to the main app and a context menu to launch Streamlit.

NOTE: In the current version, this extensions launches a bash script (`../streamlit-launcher.sh`) in a new Terminal Window in JupyterLab. This script has to be included in the notebook container image and accessible in the PATH.

TODO: switch to a Python Launcher to include with the extension package.

![Streamlit Menu](preview.png)

For full information on how to develop and package a JupyterLab extension, please refer to the documentation: https://jupyterlab.readthedocs.io/en/stable/extension/extension_dev.html

Quick development tips:

* Work from a virtual environment created from the main container Pipfile: run `pipenv install` from the `container` folder, then `pipenv shell` to activate.
* Build the extension: run `jlpm build` (jlpm is the yarn fixed version that goes along with JupyterLab)
* Build and watch for changes with `jlpm watch`
* From a second terminal (activate the same virtualenv), launch JupyterLab in watch mode: `jupyter lab --watch`
* Build the Python package: `python -m build`