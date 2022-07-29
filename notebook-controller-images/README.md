# JupyterHub Custom Notebook Images

Those images were created to be used with ODH or RHODS with Kubeflow Notebook Controller as the launcher (from ODH1.4 and RHODS ...)

## Images build logic

Notes:

- All the images support S2I to be easily extended.
- RStudio is built on a CentOS Stream 9 as packages are missing to install R properly in the UBI lines (even with all base repos and epel enabled).

```mermaid
graph TB
    ubi8py38[UBI8 Python 3.8]-->base-ubi8py38
    base-ubi8py38["Base<br/>(ubi8 py38)"]-->minimal-ubi8py38
    minimal-ubi8py38["Minimal Notebook<br/>(ubi8 py38)"]-->datascience-ubi8py38
    datascience-ubi8py38["DataScience Notebook<br/>(ubi8 py38)"]

    ubi8py39[UBI8 Python 3.9]-->base-ubi8py39
    base-ubi8py39["Base<br/>(ubi8 py39)"]-->minimalnb-ubi8py39
    base-ubi8py39-->vscode-ubi8
    minimalnb-ubi8py39["Minimal Notebook<br/>(ubi8 py39)"]-->datascience-ubi8py39
    datascience-ubi8py39["DataScience Notebook<br/>(ubi8 py39)"]
    vscode-ubi8["VSCode<br/>(ubi8 py39)"]

    centosstream9[CentOS Stream 9]-->base-centosstream9py39
    base-centosstream9py39["Base<br/>(c9s py39)"]-->rstudio-ubi8
    rstudio-ubi8["RStudio<br/>(c9s py39)"]

```
