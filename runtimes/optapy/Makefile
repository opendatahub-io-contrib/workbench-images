.PHONY: default ubi9-py39 validate-py39

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')

default:
	@echo "Options are:"
	@echo "ubi9-py39 : builds an image based on UBI9 with Python 3.9"
	@echo "---"
	@echo "Please specify the base image with BASE_IMAGE=..."
	@echo "Please specify the image tag with TAG=..."

ubi9-py39:
	cd container && podman build --build-arg=RELEASE=${RELEASE} \
								--build-arg=DATE=${DATE} \
								--build-arg=CUDA="" \
								--build-arg=BASE_IMAGE=runtime-images:datascience-ubi9-py39_${RELEASE}_${DATE} \
								--build-arg=UBI_VERSION=ubi9 \
								--build-arg=PYTHON_VERSION=py39 \
								--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
								-t runtime-images:optapy-ubi9-py39_${RELEASE}_${DATE} .
