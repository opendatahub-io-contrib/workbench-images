.PHONY: default ubi8-py38 ubi8-py39 c9s-py39

TAG ?= $(shell git describe --tags --always --dirty)

default:
	@echo "Options are:"
	@echo "ubi9-py39 : builds an image based on UBI9 with Python 3.9"
	@echo "c9s-py39 : builds an image based on CentOS Stream 9 with Python 3.9"
	@echo "ubi8-py38 : builds an image based on UBI8 with Python 3.8"
	@echo "---"
	@echo "Please specify the image tag with TAG=..."

ubi9-py39:
	cd ubi9 && podman build --build-arg=BASE_IMAGE="registry.access.redhat.com/ubi9/python-39" --build-arg=UBI_VERSION=ubi9 --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-base-ubi9-py39:${TAG} .

c9s-py39:
	cd c9s && podman build --build-arg=BASE_IMAGE="quay.io/centos/centos:stream9" --build-arg=COS_VERSION=c9s --build-arg=PYTHON_VERSION=py39 --build-arg=PYTHON_VERSION_LONG="Python 3.9" -t s2i-base-c9s-py39:${TAG} .

ubi8-py38:
	cd ubi8 && podman build --build-arg=BASE_IMAGE="registry.access.redhat.com/ubi8/python-38" --build-arg=UBI_VERSION=ubi8 --build-arg=PYTHON_VERSION=py38 --build-arg=PYTHON_VERSION_LONG="Python 3.8" -t s2i-base-ubi8-py38:${TAG} .

