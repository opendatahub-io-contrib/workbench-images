# Code-Server (VSCode) image

Standalone Code-Server (VSCode) image. **The ODH or RHODS dashboards are not compatible** with this image yet. However, a standalone deployment file using the Kubeflow Notebook Controller is available: `code-server-example.yaml`

Images are available at [quay.io/opendatahub-io-contrib/workbench-images](https://quay.io/opendatahub-io-contrib/workbench-images)

## Standard image

Build example from UBI9 with Python 3.9:

```bash
make ubi9-py39 RELEASE=dev DATE=20221206
```

## CUDA image

Build example from UBI9 with Python 3.9 with CUDA:

```bash
make cuda-ubi9-py39 RELEASE=dev DATE=20221206
```
