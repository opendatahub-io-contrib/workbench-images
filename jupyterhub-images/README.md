# JupyterHub Custom Notebook Images

Those images were created to be used with ODH or RHODS with JupyterHub as the launcher (up to ODH1.3 and RHODS ...). However, they are now compatible with the new Kubeflow Notebook Controller.

* OptaPy: Minimal JupyterLab notebook including [OptaPy](https://www.optapy.org/optapy/latest/optapy-introduction/optapy-introduction.html), the Python version of OptaPlanner.
* R: Minimal JupyterLab notebook including [R](https://www.r-project.org/) (4.0.5) and [RStudio](https://www.rstudio.com/products/rstudio/) (2022.02.0).
* SageMath: Minimal JupyterLab notebook including [SageMath](https://www.sagemath.org/) 9.3
* Streamlit: Standard Data Science notebook image including [Streamlit](https://streamlit.io/) 1.10.0
* Monai: Data Science notebook image including [Monai](https://monai.io/) 0.9.0, CUDA 11.6.2 and Streamlit 1.10.0

## Deployment

In each custom notebook folder you will find a `deploy` folder with an ImageStream YAML file. Simply apply this file in your Open Data Hub namespace (e.g. `oc apply -n opendatahub -f s2i-minimal-data-science-streamlit-notebook_image-stream.yaml`) and the new notebook image will appear in your JupyterHub menu.

## Pre-built images

Pre-built versions of the images are available:

* OptaPy: https://quay.io/guimou/s2i-minimal-data-science-optapy-notebook
* R: https://quay.io/guimou/odh-minimal-data-science-r-notebook
* SageMath: https://quay.io/guimou/s2i-minimal-data-science-sagemath-notebook
* Streamlit: https://quay.io/guimou/s2i-generic-data-science-streamlit-notebook
* Monai: https://quay.io/guimou/guimou/s2i-monai-notebook
* VSCode: https://quay.io/guimou/odh-generic-data-science-vscode-notebook
