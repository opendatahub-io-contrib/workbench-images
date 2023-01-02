# Python 3.9 Datascience Notebook

This recipe is tagged as Python 3.9 because of the Pipfile that fixes the Python version.

## Standard images

Build example from UBI9 with Python 3.9:

```bash
make ubi9-py39 RELEASE=dev DATE=20221206
```

Build example from CentOS Stream 9 with Python 3.9:

```bash
make c9s-py39 RELEASE=dev DATE=20221206
```

## CUDA images

Build example from UBI9 with Python 3.9 with CUDA:

```bash
make cuda-ubi9-py39 RELEASE=dev DATE=20221206
```

Build example from CentOS Stream 9 with Python 3.9 with CUDA:

```bash
make cuda-c9s-py39 RELEASE=dev DATE=20221206
```
