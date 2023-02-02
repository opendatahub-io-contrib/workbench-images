# DataScience Notebook image

Generic DataScience JupyterLab notebook image.

Here is the list of the main packages included:

## Datascience and useful extensions

| Package        | Version       | Description                                            |
|----------------|---------------|--------------------------------------------------------|
| elyra[kfp-tekton] | ~=3.14.1      | Extension for JupyterLab with functionality for KFP     |
| black          | ~=22.12.0     | Python code formatting tool                             |
| boto3          | ~=1.26.41     | AWS SDK for Python                                     |
| jupyter-bokeh  | ~=3.0.5       | Extension for JupyterLab with Bokeh support            |
| jupyter-contrib-nbextensions | ~=0.7.0 | Collection of extensions for Jupyter Notebook          |
| jupyterlab-lsp | ~=3.10.2      | Extension for JupyterLab with language server support  |
| jupyterlab-tabnine | ~=0.0.24  | Extension for JupyterLab with TabNine code completion  |
| jupyterlab-widgets | ~=3.0.5   | Extension for JupyterLab with interactive widgets      |
| kafka-python   | ~=2.0.2       | Kafka client for Python                                |
| matplotlib     | ~=3.6.3       | Data visualization library for Python                   |
| numpy          | ~=1.24.1      | Numerical computing library for Python                 |
| pandas         | ~=1.5.3       | Data manipulation and analysis library for Python      |
| plotly         | ~=5.13.0      | Data visualization library for Python                   |
| scikit-learn   | ~=1.2.1       | Machine learning library for Python                     |
| scipy          | ~=1.10.0       | Scientific computing library for Python                |
| streamlit      | ~=1.17.0      | Library for building data science applications in Python |

## Parent image requirements to maintain cohesion

| Package               | Version       | Description                                            |
|-----------------------|---------------|--------------------------------------------------------|
| jupyter-resource-usage | ~=0.7.0      | Extension for JupyterLab to monitor resource usage     |
| jupyter-server-proxy   | ~=3.2.2      | Extension for JupyterLab to proxy web applications      |
| jupyterlab-git         | ~=0.41.0     | Extension for JupyterLab with Git integration          |
| nbdime                 | ~=3.1.1      | Extension for JupyterLab to compare notebooks          |
| nbgitpuller            | ~=1.1.1      | Extension for JupyterLab to pull notebooks from Git    |

NOTE: The version is specified using the ~= operator, which allows the package to be updated within the specified version range as long as the updates are compatible with the other packages in the environment.
