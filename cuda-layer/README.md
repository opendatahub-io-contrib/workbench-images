# CUDA base images

Base images from CentOS Stream 9 with Python 9 or Python 3.11 and CUDA 11.8

- Building and verifying all the images:

```bash
make all RELEASE=dev DATE=20230910
```

- Building the images:

```bash
make c9s-py39 RELEASE=dev DATE=20230910
```

- Verifying the images:

```bash
make validate-py39 RELEASE=dev DATE=20230910
```
