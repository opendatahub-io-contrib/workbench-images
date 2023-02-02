# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [2023b] - 2023-02-01

- Update to the CUDA RStudio and Jupyter + RStudio images to include the CUDA toolkit. This is necessary to install certain packages that are compiled in-place.
- Update to RStudio and VSCode images (standalone versions). They are now fully compatible with the dashboard, so can be used as standard custom images. Idle culling also works with those images.
- Addition of some packages:
  - Minimal:
    - jupyter-server-terminals ~=0.4.4 and jupyter-server ~=2.1.0: this will allow culling to work for terminals once enable on the notebook controller.
- Updates of some packages versions:
  - Minimal:
    - jupyterlab ~=3.5.2 -> ~=3.5.3
    - jupyter-resource-usage: ~=0.6.4 -> ~=0.7.0
  - Datascience:
    - matplotlib ~=3.6.2 -> ~=3.6.3
    - pandas ~=1.5.2 -> ~=1.5.3
    - plotly ~=5.11.0 -> ~=5.13.0
    - scikit-learn ~=1.2.0 -> ~=1.2.1
    - scipy ~=1.9.3 -> ~=1.10.0
    - streamlit ~=1.16.0  -> ~=1.17.0

## [2023a] - 2023-01-02

- Migration of repository to opendatahub-io-contrib organization
- Modification of versioning scheme to allow multiple parallel releases and automated regular updates as described [here](README.md#naming-convention)
- Full refactoring of the repository for clarity
- Adding tests to the Makefiles to validate images
- Release of 2023a, creation of associated support branch

## [0.0.15] - 2022-12-02

- Spark notebook in the `notebook-controller-images` folder. This is a JupyterLab Data Science notebook with Spark 3.3.1 and Hadoop 3.3.4.
- Also includes RBAC and examples for launching Spark workloads directly from the notebook.

## [0.0.14] - 2022-10-23

- VSCode notebook in the `jupyterhub-images` folder. This is a JupyterLab Data Science notebook that also includes VSCode 4.7.1. This image works both with JupyterHub and current ODH/RHODS dashboard version (contrary to the image in `notebook-controller-images` that works only with the Kubeflow Notebook Controller and is not compatible with ODH/RHODS dashboard).

## [0.0.13] - 2022-10-05

- Monai notebook in the `notebook-controller-images` line. As it's not thoroughly tested it's still not officially released
- OptaPy custom image updated with OptaPy 8.23.0a0, minimal-data-science-optapy-notebook:v0.0.2
- All images, including those in the `jupyterhub-images` folder are now compatible with the Kubeflow Notebook Controller

## [0.0.12] - 2022-08-04

### Added

- New organization of images for upcoming Kubeflow Notebook Controller
- Base, Minimal, Data Science, Code-Server and RStudio images available in the new `notebook-controller-images` line

## [0.0.11] - 2022-06-24

### Added

- New notebook image: CUDA 11.6.2 + Monai 0.9.0 + Streamlit 1.10.0 notebook (quay.io/guimou/monai-notebook:0.0.2)

### Modified

- Streamlit image updated to streamlit 1.10.0 - fixes #5
- fix Streamlit launch scripts for directory context - fixes #6
- new streamlit image: quay.io/guimou/generic-data-science-streamlit-notebook:0.0.7

## [0.0.10] - 2022-06-22

### Added

- nbgitpuller added to Streamlit notebook (quay.io/guimou/generic-data-science-streamlit-notebook:0.0.6)

### Modified

- fix yarn cache clean on Streamlit notebook image
- prebuilt-images repos added to CHANGELOG

## [0.0.9] - 2022-06-08

### Added

- Streamlit notebook (quay.io/guimou/generic-data-science-streamlit-notebook:0.0.5)

## [0.0.8] - 2022-03-28

### Added

- Changelog file
- SageMath notebook (quay.io/guimou/minimal-data-science-sagemath-notebook:0.0.1)

## [0.0.7] - 2022-03-25

### Added

- RStudio added to the R notebook (quay.io/guimou/odh-minimal-data-science-r-notebook:0.0.15)

## [0.0.6] - 2022-03-23

### Added

- OptaPy notebook added (quay.io/guimou/minimal-data-science-optapy-notebook:v0.0.1)
