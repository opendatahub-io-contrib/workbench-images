# Python 3.9 Minimal Notebook

This recipe is tagged as Python 3.9 because of the Pipfile that fixes the Python version.

## Standard images

Build example from UBI9 with Python 3.9:

```bash
make ubi9-py39 BASE_IMAGE=localhost/s2i-minimal-notebook-ubi9-py39:0.0.1 TAG=0.0.1
```

Build example from CentOS Stream 9 with Python 3.9:

```bash
make c9s-py39 BASE_IMAGE=localhost/s2i-minimal-notebook-c9s-py39:0.0.1 TAG=0.0.1
```

## CUDA images

Build example from UBI9 with Python 3.9 with CUDA:

```bash
make cuda-ubi9-py39 BASE_IMAGE=localhost/s2i-minimal-cuda-notebook-ubi9-py39:0.0.1 TAG=0.0.1
```

Build example from CentOS Stream 9 with Python 3.9 with CUDA:

```bash
make cuda-c9s-py39 BASE_IMAGE=localhost/s2i-minimal-cuda-notebook-c9s-py39:0.0.1 TAG=0.0.1
```
