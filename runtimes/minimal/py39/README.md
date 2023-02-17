# Python 3.9 Minimal Notebook

This recipe is tagged as Python 3.9 because of the Pipfile in the minimal folder that fixes the Python version.

## Standard images

Build example from UBI9 with Python 3.9:

```bash
make ubi9-py39 RELEASE=dev DATE=20230101
```

Build example from CentOS Stream 9 with Python 3.9:

```bash
make c9s-py39 RELEASE=dev DATE=20230101
```

## CUDA images

Build example from UBI9 with Python 3.9 with CUDA:

```bash
make cuda-ubi9-py39 RELEASE=dev DATE=20230101
```

Build example from CentOS Stream 9 with Python 3.9 with CUDA:

```bash
make cuda-c9s-py39 RELEASE=dev DATE=20230101
```
