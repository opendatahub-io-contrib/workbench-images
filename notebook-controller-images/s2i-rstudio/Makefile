.PHONY: default c9s-py39

TAG ?= $(shell git describe --tags --always --dirty)

default:
	@echo "Options are:"
	@echo "c9s-py39 : builds an image based on CentOS Stream 9 with Python 3.9"
	@echo "---"
	@echo "Please specify the base image with BASE_IMAGE=..."
	@echo "Please specify the image tag with TAG=..."

c9s-py39:
	cd container && podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} --build-arg=COS_VERSION=c9s --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-rstudio-c9s-py39:${TAG} .
