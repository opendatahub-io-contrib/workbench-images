.PHONY: default ubi9-py39

TAG ?= $(shell git describe --tags --always --dirty)

default:
	@echo "Options are:"
	@echo "ubi9-py39 : builds an image based on UBI9 with Python 3.9"
	@echo "---"
	@echo "Please specify the base image with BASE_IMAGE=..."
	@echo "Please specify the image tag with TAG=..."

ubi9-py39:
	cd container && podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} --build-arg=UBI_VERSION=ubi9 --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-spark-notebook-ubi9-py39:${TAG} .
