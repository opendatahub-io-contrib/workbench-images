# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Nothing

## [0.0.13] - 2022-10-05

- Monai notebook in the `notebook-controller-images` line. As it's not thoroughly tested it's still not officially released
- OptaPy custom image updated with OptaPy 8.23.0a0, s2i-minimal-data-science-optapy-notebook:v0.0.2
- All images, including those in the `jupyterhub-images` folder are now compatible with the Kubeflow Notebook Controller

## [0.0.12] - 2022-08-04

### Added

- New organization of images for upcoming Kubeflow Notebook Controller
- Base, Minimal, Data Science, Code-Server and RStudio images available in the new `notebook-controller-images` line

## [0.0.11] - 2022-06-24

### Added

- New notebook image: CUDA 11.6.2 + Monai 0.9.0 + Streamlit 1.10.0 notebook (quay.io/guimou/s2i-monai-notebook:0.0.2)

### Modified

- Streamlit image updated to streamlit 1.10.0 - fixes #5
- fix Streamlit launch scripts for directory context - fixes #6
- new streamlit image: quay.io/guimou/s2i-generic-data-science-streamlit-notebook:0.0.7

## [0.0.10] - 2022-06-22

### Added

- nbgitpuller added to Streamlit notebook (quay.io/guimou/s2i-generic-data-science-streamlit-notebook:0.0.6)

### Modified

- fix yarn cache clean on Streamlit notebook image
- prebuilt-images repos added to CHANGELOG

## [0.0.9] - 2022-06-08

### Added

- Streamlit notebook (quay.io/guimou/s2i-generic-data-science-streamlit-notebook:0.0.5)

## [0.0.8] - 2022-03-28

### Added

- Changelog file
- SageMath notebook (quay.io/guimou/s2i-minimal-data-science-sagemath-notebook:0.0.1)

## [0.0.7] - 2022-03-25

### Added

- RStudio added to the R notebook (quay.io/guimou/odh-minimal-data-science-r-notebook:0.0.15)

## [0.0.6] - 2022-03-23

### Added

- OptaPy notebook added (quay.io/guimou/s2i-minimal-data-science-optapy-notebook:v0.0.1)
