# Custom notebook images

*[See changelog](CHANGELOG.md)*

Various custom Jupyter Notebook Images to use with [Open Data Hub](http://opendatahub.io/) or [Red Hat OpenShift Data Science](https://www.redhat.com/fr/technologies/cloud-computing/openshift/openshift-data-science).

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
* Monai: https://quay.io/repository/guimou/s2i-monai-notebook
