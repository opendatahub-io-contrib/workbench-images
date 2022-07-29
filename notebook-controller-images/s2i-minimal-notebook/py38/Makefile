.PHONY: default ubi8-py38

TAG ?= $(shell git describe --tags --always --dirty)

default:
	@echo "Options are:"
	@echo "ubi8-py38 : builds an image based on UBI8 with Python 3.8"
	@echo "---"
	@echo "Please specify the base image with BASE_IMAGE=..."
	@echo "Please specify the image tag with TAG=..."

ubi8-py38:
	podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} --build-arg=UBI_VERSION=ubi8 --build-arg=PYTHON_VERSION=py38 --build-arg=PYTHON_VERSION_LONG="Python 3.8" -t s2i-minimal-notebook-ubi8-py38:${TAG} .
