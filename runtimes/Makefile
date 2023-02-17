.PHONY: default ubi8-py38 ubi9-py39 c9s-py39 all build-all refresh-pipfile-lock

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')
REPO ?= quay.io/opendatahub-contrib/runtime-images

default:
	@echo "This Makefile builds minimal and datascience runtime images"
	@echo "and their CUDA versions for different platforms."
	@echo "It also builds R, Spark and other runtimes."
	@echo "Options are:"
	@echo "all : builds and pushed all flavors of images"
	@echo "refresh-pipfile-lock : only refreshes the various Pipfile.lock"
	@echo "ubi9-py39 : builds images based on UBI9 with Python 3.9"
	@echo "c9s-py39 : builds images based on CentOS Stream 9 with Python 3.9"
	@echo "ubi8-py38 : builds images based on UBI8 with Python 3.8"
	@echo "push-all : push all images"
	@echo "push-ubi9-py39 : push images based on UBI9 with Python 3.9"
	@echo "push-c9s-py39 : push images based on CentOS Stream 9 with Python 3.9"
	@echo "push-ubi8-py38 : push images based on UBI8 with Python 3.8"
	@echo "---"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to git tag or 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"
	@echo " - the repository to push to with REPO=... (defaults to 'quay.io/opendatahub-contrib/runtime-images')"

all: refresh-pipfile-lock build-all push-all

build-all: ubi9-py39 c9s-py39 ubi8-py38

# Refreshes all pipfile.lock files
refresh-pipfile-lock:
	cd minimal/py38 && pipenv lock
	cd minimal/py39 && pipenv lock
	cd datascience/py38 && pipenv lock
	cd datascience/py39 && pipenv lock
	cd monai/container && pipenv lock
	cd optapy/container && pipenv lock

ubi9-py39:
	cd minimal/py39 && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd minimal/py39 && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd datascience/py39 && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd datascience/py39 && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd spark && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd spark && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd optapy && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE}
	
c9s-py39:
	cd minimal/py39 && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd minimal/py39 && make cuda-c9s-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd datascience/py39 && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd datascience/py39 && make cuda-c9s-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd monai && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd r && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE}
	cd r && make cuda-c9s-py39 RELEASE=${RELEASE} DATE=${DATE}

ubi8-py38:
	cd minimal/py38 && make ubi8-py38 RELEASE=${RELEASE} DATE=${DATE}
	cd minimal/py38 && make cuda-ubi8-py38 RELEASE=${RELEASE} DATE=${DATE}
	cd datascience/py38 && make ubi8-py38 RELEASE=${RELEASE} DATE=${DATE}
	cd datascience/py38 && make cuda-ubi8-py38 RELEASE=${RELEASE} DATE=${DATE}

push-all: push-ubi9-py39 push-c9s-py39 push-ubi8-py38

push-ubi9-py39:
	podman push localhost/runtime-images:cuda-datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-datascience-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:cuda-minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-minimal-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:cuda-spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-spark-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:datascience-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:minimal-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:optapy-ubi9-py39_${RELEASE}_${DATE} ${REPO}:optapy-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:spark-ubi9-py39_${RELEASE}_${DATE}
# Push latest tag to all new images	
	podman push localhost/runtime-images:cuda-datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-datascience-ubi9-py39_${RELEASE}_latest
	podman push localhost/runtime-images:cuda-minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-minimal-ubi9-py39_${RELEASE}_latest
	podman push localhost/runtime-images:cuda-spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-spark-ubi9-py39_${RELEASE}_latest
	podman push localhost/runtime-images:datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:datascience-ubi9-py39_${RELEASE}_latest
	podman push localhost/runtime-images:minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:minimal-ubi9-py39_${RELEASE}_latest
	podman push localhost/runtime-images:optapy-ubi9-py39_${RELEASE}_${DATE} ${REPO}:optapy-ubi9-py39_${RELEASE}_latest
	podman push localhost/runtime-images:spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:spark-ubi9-py39_${RELEASE}_latest


push-c9s-py39:
	podman push localhost/runtime-images:cuda-datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-datascience-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:cuda-minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-minimal-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:cuda-r-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-r-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:datascience-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:minimal-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:monai-c9s-py39_${RELEASE}_${DATE} ${REPO}:monai-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/runtime-images:r-c9s-py39_${RELEASE}_${DATE} ${REPO}:r-c9s-py39_${RELEASE}_${DATE}
# Push latest tag to all new images
	podman push localhost/runtime-images:cuda-datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-datascience-c9s-py39_${RELEASE}_latest
	podman push localhost/runtime-images:cuda-minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-minimal-c9s-py39_${RELEASE}_latest
	podman push localhost/runtime-images:cuda-r-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-r-c9s-py39_${RELEASE}_latest
	podman push localhost/runtime-images:datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:datascience-c9s-py39_${RELEASE}_latest
	podman push localhost/runtime-images:minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:minimal-c9s-py39_${RELEASE}_latest
	podman push localhost/runtime-images:monai-c9s-py39_${RELEASE}_${DATE} ${REPO}:monai-c9s-py39_${RELEASE}_latest
	podman push localhost/runtime-images:r-c9s-py39_${RELEASE}_${DATE} ${REPO}:r-c9s-py39_${RELEASE}_latest

push-ubi8-py38:
	podman push localhost/runtime-images:cuda-datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-datascience-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/runtime-images:cuda-minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-minimal-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/runtime-images:datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:datascience-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/runtime-images:minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:minimal-ubi8-py38_${RELEASE}_${DATE}
# Push latest tag to all new images	
	podman push localhost/runtime-images:cuda-datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-datascience-ubi8-py38_${RELEASE}_latest
	podman push localhost/runtime-images:cuda-minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-minimal-ubi8-py38_${RELEASE}_latest
	podman push localhost/runtime-images:datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:datascience-ubi8-py38_${RELEASE}_latest
	podman push localhost/runtime-images:minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:minimal-ubi8-py38_${RELEASE}_latest
