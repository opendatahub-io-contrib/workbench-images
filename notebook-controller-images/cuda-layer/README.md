# CUDA images build chain

Build example  from UBI9 with Python 3.9:

```bash
make ubi9-py39 BASE_IMAGE=localhost/s2i-base-ubi9-py39:0.0.1 TAG=0.0.1
```

Build example  from CentOS Stream 9 with Python 3.9:

```bash
make c9s-py39 BASE_IMAGE=localhost/s2i-base-c9s-py39:0.0.1 TAG=0.0.1
```

Build example  from UBI8 with Python 3.8:

```bash
make ubi8-py38 BASE_IMAGE=localhost/s2i-base-ubi8-py38:0.0.1 TAG=0.0.1
```
