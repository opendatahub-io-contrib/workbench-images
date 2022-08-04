.PHONY: default ubi8-py39 c9s-py39 cuda-ubi9-py39 cuda-c9s-py39

TAG ?= $(shell git describe --tags --always --dirty)

default:
	@echo "Options are:"
	@echo "Standard images:"
	@echo "ubi9-py39 : builds an image based on UBI9 with Python 3.9"
	@echo "c9s-py39 : builds an image based on CentOS Stream 9 with Python 3.9"
	@echo ""
	@echo "CUDA images:"
	@echo "cuda-ubi9-py39 : builds an image based on UBI9 with Python 3.9"
	@echo "cuda-c9s-py39 : builds an image based on CentOS Stream 9 with Python 3.9"
	@echo "---"
	@echo "Please specify the base image with BASE_IMAGE=..."
	@echo "Please specify the image tag with TAG=..."

ubi9-py39:
	podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} --build-arg=UBI_VERSION=ubi9 --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-datascience-notebook-ubi9-py39:${TAG} .

c9s-py39:
	podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} --build-arg=UBI_VERSION=c9s --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-datascience-notebook-c9s-py39:${TAG} .

cuda-ubi9-py39:
	podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} --build-arg=UBI_VERSION=ubi9 --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-datascience-cuda-notebook-ubi9-py39:${TAG} .

cuda-c9s-py39:
	podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} --build-arg=UBI_VERSION=c9s --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-datascience-cuda-notebook-c9s-py39:${TAG} .
