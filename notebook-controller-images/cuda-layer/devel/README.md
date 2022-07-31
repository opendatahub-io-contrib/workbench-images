# Build instructions

Build from a local base image (e.g. localhost/cuda:11.6.2-base-centosstream9)

```bash
podman build --build-arg=IMAGE_NAME=localhost/cuda:11.6.2-runtime-centosstream9 -t cuda:11.6.2-devel-centosstream9 .
```

Build CUDNN version from a local runtime image (e.g. localhost/cuda:11.6.2-runtime-centosstream9)

From the cudnn8 folder:

```bash
podman build --build-arg=IMAGE_NAME=localhost/cuda:11.6.2-devel-centosstream9 -t cuda:11.6.2-cudnn8-devel-centosstream9 .
```
