# Python base image

Base image from CentOS Stream 9 with Python 3.9 or Python 3.11.

It comes with a set of base OS packages and libraries, and a properly configured environment for child images.

As many updates and installations are made, this is a flattened image using multistage to minimize its size.

## Make

- Building and verifying the images:

```bash
make all RELEASE=dev DATE=20230910
```

- Building an image:

```bash
make c9s-py39 RELEASE=dev DATE=20230910
```

- Verifying an image:

```bash
make validate-py39 RELEASE=dev DATE=20230910
```
