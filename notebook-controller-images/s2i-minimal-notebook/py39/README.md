# Python 3.9 Minimal Notebook

This recipe is tagged as Python 3.9 because of the Pipfile in the minimal folder that fixes the Python version.

## Standard images

Build example  from UBI9 with Python 3.9:

```bash
make ubi9-py39 BASE_IMAGE=localhost/s2i-base-ubi9-py39:0.0.1 TAG=0.0.1
```

Build example  from CentOS Stream 9 with Python 3.9:

```bash
make c9s-py39 BASE_IMAGE=localhost/s2i-base-c9s-py39:0.0.1 TAG=0.0.1
```

## CUDA images

Build example  from UBI9 with Python 3.9 with CUDA:

```bash
make cuda-ubi9-py39 BASE_IMAGE=localhost/s2i-base-cuda-ubi9-py39:0.0.1 TAG=0.0.1
```

Build example  from CentOS Stream 9 with Python 3.9 with CUDA:

```bash
make cuda-c9s-py39 BASE_IMAGE=localhost/s2i-base-cuda-c9s-py39:0.0.1 TAG=0.0.1
```
