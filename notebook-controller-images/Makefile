.PHONY: default ubi8-py38 ubi9-py39 c9s-py39 all

TAG ?= $(shell git describe --tags --always --dirty)

default:
	@echo "This Makefile builds base, minimal-notebook and datascience-notebook images and their CUDA versions for different platforms."
	@echo "Options are:"
	@echo "all : build all flavors of images"
	@echo "ubi9-py39 : build images based on UBI9 with Python 3.9"
	@echo "c9s-py39 : build images based on CentOS Stream 9 with Python 3.9"
	@echo "ubi8-py38 : build images based on UBI8 with Python 3.9"
	@echo "push-all : push all images"
	@echo "push-ubi9-py39 : push images based on UBI9 with Python 3.9"
	@echo "push-c9s-py39 : push images based on CentOS Stream 9 with Python 3.9"
	@echo "push-ubi8-py38 : push images based on UBI8 with Python 3.9"
	@echo "---"
	@echo "Please specify the image tag with TAG=..."
	@echo "For pushing, please specify the repository with REPO=... (no trailing slash)" 

all: refresh-pipfile-lock ubi9-py39 c9s-py39 ubi8-py38

refresh-pipfile-lock:
	cd s2i-minimal-notebook/py38/minimal && pipenv lock
	cd s2i-minimal-notebook/py39/minimal && pipenv lock
	cd s2i-datascience-notebook/py38 && pipenv lock
	cd s2i-datascience-notebook/py39 && pipenv lock

ubi9-py39:
	cd s2i-base-py && make ubi9-py39 TAG=${TAG}
	cd s2i-minimal-notebook/py39 && make ubi9-py39 TAG=${TAG} BASE_IMAGE=s2i-base-ubi9-py39:${TAG}
	cd s2i-datascience-notebook/py39 && make ubi9-py39 TAG=${TAG} BASE_IMAGE=s2i-minimal-notebook-ubi9-py39:${TAG}
	cd cuda-layer && make ubi9-py39 TAG=${TAG} BASE_IMAGE=s2i-base-ubi9-py39:${TAG}
	cd s2i-minimal-notebook/py39 && make cuda-ubi9-py39 TAG=${TAG} BASE_IMAGE=s2i-base-cuda-ubi9-py39:${TAG}
	cd s2i-datascience-notebook/py39 && make cuda-ubi9-py39 TAG=${TAG} BASE_IMAGE=s2i-minimal-cuda-notebook-ubi9-py39:${TAG}

c9s-py39:
	cd s2i-base-py && make c9s-py39 TAG=${TAG}
	cd s2i-minimal-notebook/py39 && make c9s-py39 TAG=${TAG} BASE_IMAGE=s2i-base-c9s-py39:${TAG}
	cd s2i-datascience-notebook/py39 && make c9s-py39 TAG=${TAG} BASE_IMAGE=s2i-minimal-notebook-c9s-py39:${TAG}
	cd cuda-layer && make c9s-py39 TAG=${TAG} BASE_IMAGE=s2i-base-c9s-py39:${TAG}
	cd s2i-minimal-notebook/py39 && make cuda-c9s-py39 TAG=${TAG} BASE_IMAGE=s2i-base-cuda-c9s-py39:${TAG}
	cd s2i-datascience-notebook/py39 && make cuda-c9s-py39 TAG=${TAG} BASE_IMAGE=s2i-minimal-cuda-notebook-c9s-py39:${TAG}

ubi8-py38:
	cd s2i-base-py && make ubi8-py38 TAG=${TAG}
	cd s2i-minimal-notebook/py38 && make ubi8-py38 TAG=${TAG} BASE_IMAGE=s2i-base-ubi8-py38:${TAG}
	cd s2i-datascience-notebook/py38 && make ubi8-py38 TAG=${TAG} BASE_IMAGE=s2i-minimal-notebook-ubi8-py38:${TAG}
	cd cuda-layer && make ubi8-py38 TAG=${TAG} BASE_IMAGE=s2i-base-ubi8-py38:${TAG}
	cd s2i-minimal-notebook/py38 && make cuda-ubi8-py38 TAG=${TAG} BASE_IMAGE=s2i-base-cuda-ubi8-py38:${TAG}
	cd s2i-datascience-notebook/py38 && make cuda-ubi8-py38 TAG=${TAG} BASE_IMAGE=s2i-minimal-cuda-notebook-ubi8-py38:${TAG}

push-all: push-ubi9-py39 push-c9s-py39 push-ubi8-py38

push-ubi9-py39:
	podman push localhost/s2i-base-cuda-ubi9-py39:${TAG} ${REPO}/s2i-base-cuda-ubi9-py39:${TAG}
	podman push localhost/s2i-base-ubi9-py39:${TAG} ${REPO}/s2i-base-ubi9-py39:${TAG}
	podman push localhost/s2i-base-ubi9-py39-cuda-base:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-base:${TAG}
	podman push localhost/s2i-base-ubi9-py39-cuda-devel:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-devel:${TAG}
	podman push localhost/s2i-base-ubi9-py39-cuda-devel-cudnn:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-devel-cudnn:${TAG}
	podman push localhost/s2i-base-ubi9-py39-cuda-runtime:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-runtime:${TAG}
	podman push localhost/s2i-base-ubi9-py39-cuda-runtime-cudnn:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-runtime-cudnn:${TAG}
	podman push localhost/s2i-datascience-cuda-notebook-ubi9-py39:${TAG} ${REPO}/s2i-datascience-cuda-notebook-ubi9-py39:${TAG}
	podman push localhost/s2i-datascience-notebook-ubi9-py39:${TAG} ${REPO}/s2i-datascience-notebook-ubi9-py39:${TAG}
	podman push localhost/s2i-minimal-cuda-notebook-ubi9-py39:${TAG} ${REPO}/s2i-minimal-cuda-notebook-ubi9-py39:${TAG}
	podman push localhost/s2i-minimal-notebook-ubi9-py39:${TAG} ${REPO}/s2i-minimal-notebook-ubi9-py39:${TAG}
# Push latest tag to all new images	
	podman push localhost/s2i-base-cuda-ubi9-py39:${TAG} ${REPO}/s2i-base-cuda-ubi9-py39:latest
	podman push localhost/s2i-base-ubi9-py39:${TAG} ${REPO}/s2i-base-ubi9-py39:latest
	podman push localhost/s2i-base-ubi9-py39-cuda-base:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-base:latest
	podman push localhost/s2i-base-ubi9-py39-cuda-devel:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-devel:latest
	podman push localhost/s2i-base-ubi9-py39-cuda-devel-cudnn:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-devel-cudnn:latest
	podman push localhost/s2i-base-ubi9-py39-cuda-runtime:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-runtime:latest
	podman push localhost/s2i-base-ubi9-py39-cuda-runtime-cudnn:${TAG} ${REPO}/s2i-base-ubi9-py39-cuda-runtime-cudnn:latest
	podman push localhost/s2i-datascience-cuda-notebook-ubi9-py39:${TAG} ${REPO}/s2i-datascience-cuda-notebook-ubi9-py39:latest
	podman push localhost/s2i-datascience-notebook-ubi9-py39:${TAG} ${REPO}/s2i-datascience-notebook-ubi9-py39:latest
	podman push localhost/s2i-minimal-cuda-notebook-ubi9-py39:${TAG} ${REPO}/s2i-minimal-cuda-notebook-ubi9-py39:latest
	podman push localhost/s2i-minimal-notebook-ubi9-py39:${TAG} ${REPO}/s2i-minimal-notebook-ubi9-py39:latest

push-c9s-py39:
	podman push localhost/s2i-base-cuda-c9s-py39:${TAG} ${REPO}/s2i-base-cuda-c9s-py39:${TAG}
	podman push localhost/s2i-base-c9s-py39:${TAG} ${REPO}/s2i-base-c9s-py39:${TAG}
	podman push localhost/s2i-base-c9s-py39-cuda-base:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-base:${TAG}
	podman push localhost/s2i-base-c9s-py39-cuda-devel:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-devel:${TAG}
	podman push localhost/s2i-base-c9s-py39-cuda-devel-cudnn:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-devel-cudnn:${TAG}
	podman push localhost/s2i-base-c9s-py39-cuda-runtime:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-runtime:${TAG}
	podman push localhost/s2i-base-c9s-py39-cuda-runtime-cudnn:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-runtime-cudnn:${TAG}
	podman push localhost/s2i-datascience-cuda-notebook-c9s-py39:${TAG} ${REPO}/s2i-datascience-cuda-notebook-c9s-py39:${TAG}
	podman push localhost/s2i-datascience-notebook-c9s-py39:${TAG} ${REPO}/s2i-datascience-notebook-c9s-py39:${TAG}
	podman push localhost/s2i-minimal-cuda-notebook-c9s-py39:${TAG} ${REPO}/s2i-minimal-cuda-notebook-c9s-py39:${TAG}
	podman push localhost/s2i-minimal-notebook-c9s-py39:${TAG} ${REPO}/s2i-minimal-notebook-c9s-py39:${TAG}
# Push latest tag to all new images	
	podman push localhost/s2i-base-cuda-c9s-py39:${TAG} ${REPO}/s2i-base-cuda-c9s-py39:latest
	podman push localhost/s2i-base-c9s-py39:${TAG} ${REPO}/s2i-base-c9s-py39:latest
	podman push localhost/s2i-base-c9s-py39-cuda-base:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-base:latest
	podman push localhost/s2i-base-c9s-py39-cuda-devel:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-devel:latest
	podman push localhost/s2i-base-c9s-py39-cuda-devel-cudnn:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-devel-cudnn:latest
	podman push localhost/s2i-base-c9s-py39-cuda-runtime:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-runtime:latest
	podman push localhost/s2i-base-c9s-py39-cuda-runtime-cudnn:${TAG} ${REPO}/s2i-base-c9s-py39-cuda-runtime-cudnn:latest
	podman push localhost/s2i-datascience-cuda-notebook-c9s-py39:${TAG} ${REPO}/s2i-datascience-cuda-notebook-c9s-py39:latest
	podman push localhost/s2i-datascience-notebook-c9s-py39:${TAG} ${REPO}/s2i-datascience-notebook-c9s-py39:latest
	podman push localhost/s2i-minimal-cuda-notebook-c9s-py39:${TAG} ${REPO}/s2i-minimal-cuda-notebook-c9s-py39:latest
	podman push localhost/s2i-minimal-notebook-c9s-py39:${TAG} ${REPO}/s2i-minimal-notebook-c9s-py39:latest

push-ubi8-py38:
	podman push localhost/s2i-base-cuda-ubi8-py38:${TAG} ${REPO}/s2i-base-cuda-ubi8-py38:${TAG}
	podman push localhost/s2i-base-ubi8-py38:${TAG} ${REPO}/s2i-base-ubi8-py38:${TAG}
	podman push localhost/s2i-base-ubi8-py38-cuda-base:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-base:${TAG}
	podman push localhost/s2i-base-ubi8-py38-cuda-devel:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-devel:${TAG}
	podman push localhost/s2i-base-ubi8-py38-cuda-devel-cudnn:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-devel-cudnn:${TAG}
	podman push localhost/s2i-base-ubi8-py38-cuda-runtime:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-runtime:${TAG}
	podman push localhost/s2i-base-ubi8-py38-cuda-runtime-cudnn:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-runtime-cudnn:${TAG}
	podman push localhost/s2i-datascience-cuda-notebook-ubi8-py38:${TAG} ${REPO}/s2i-datascience-cuda-notebook-ubi8-py38:${TAG}
	podman push localhost/s2i-datascience-notebook-ubi8-py38:${TAG} ${REPO}/s2i-datascience-notebook-ubi8-py38:${TAG}
	podman push localhost/s2i-minimal-cuda-notebook-ubi8-py38:${TAG} ${REPO}/s2i-minimal-cuda-notebook-ubi8-py38:${TAG}
	podman push localhost/s2i-minimal-notebook-ubi8-py38:${TAG} ${REPO}/s2i-minimal-notebook-ubi8-py38:${TAG}
# Push latest tag to all new images	
	podman push localhost/s2i-base-cuda-ubi8-py38:${TAG} ${REPO}/s2i-base-cuda-ubi8-py38:latest
	podman push localhost/s2i-base-ubi8-py38:${TAG} ${REPO}/s2i-base-ubi8-py38:latest
	podman push localhost/s2i-base-ubi8-py38-cuda-base:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-base:latest
	podman push localhost/s2i-base-ubi8-py38-cuda-devel:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-devel:latest
	podman push localhost/s2i-base-ubi8-py38-cuda-devel-cudnn:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-devel-cudnn:latest
	podman push localhost/s2i-base-ubi8-py38-cuda-runtime:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-runtime:latest
	podman push localhost/s2i-base-ubi8-py38-cuda-runtime-cudnn:${TAG} ${REPO}/s2i-base-ubi8-py38-cuda-runtime-cudnn:latest
	podman push localhost/s2i-datascience-cuda-notebook-ubi8-py38:${TAG} ${REPO}/s2i-datascience-cuda-notebook-ubi8-py38:latest
	podman push localhost/s2i-datascience-notebook-ubi8-py38:${TAG} ${REPO}/s2i-datascience-notebook-ubi8-py38:latest
	podman push localhost/s2i-minimal-cuda-notebook-ubi8-py38:${TAG} ${REPO}/s2i-minimal-cuda-notebook-ubi8-py38:latest
	podman push localhost/s2i-minimal-notebook-ubi8-py38:${TAG} ${REPO}/s2i-minimal-notebook-ubi8-py38:latest
