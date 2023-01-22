# R and RStudio Notebook Image

Datascience notebook image adding an R Kernel and RStudio to the JupyterLab launcher.

## Standard images

Build example from Centos Stream 9 with Python 3.9:

```bash
make c9s-py39 RELEASE=dev DATE=20230101
```

## CUDA images

This CUDA image include the CUDA Toolkit, which is necessary to install/build packages like Tensorflow.

NOTE: Tensorflow for R also requires the Tensorflow Python package to be installed, which is not present in this image. You have to install it prior to installing the R package.

Build example from Centos Stream 9 with Python 3.9 with CUDA:

```bash
make cuda-c9s-py39 RELEASE=dev DATE=20230101
```
