.PHONY: default ubi9-py39 cuda-ubi9-py39

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')
BASE_IMAGE ?= "workbench-images:base-ubi9-py39_${RELEASE}_${DATE}"
CUDA_BASE_IMAGE ?= "workbench-images:cuda-base-ubi9-py39_${RELEASE}_${DATE}"
C9S_BASE_IMAGE ?= "workbench-images:base-c9s-py39_${RELEASE}_${DATE}"
C9S_CUDA_BASE_IMAGE ?= "workbench-images:cuda-base-c9s-py39_${RELEASE}_${DATE}"

default:
	@echo "Options are:"
	@echo "Standard images:"
	@echo "ubi9-py39 : builds an image based on UBI9 with Python 3.8"
	@echo ""
	@echo "CUDA images:"
	@echo "cuda-ubi9-py39 : builds an image based on UBI9 with Python 3.8"
	@echo "---"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

ubi9-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=${BASE_IMAGE} \
				--build-arg=UBI_VERSION=ubi9 \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				--build-arg=CUDA="" \
				-t runtime-images:minimal-ubi9-py39_${RELEASE}_${DATE} .

cuda-ubi9-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=${CUDA_BASE_IMAGE} \
				--build-arg=UBI_VERSION=ubi9 \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				--build-arg=CUDA="cuda-" \
				-t runtime-images:cuda-minimal-ubi9-py39_${RELEASE}_${DATE} .

c9s-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=${C9S_BASE_IMAGE} \
				--build-arg=UBI_VERSION=c9s \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				--build-arg=CUDA="" \
				-t runtime-images:minimal-c9s-py39_${RELEASE}_${DATE} .

cuda-c9s-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=${C9S_CUDA_BASE_IMAGE} \
				--build-arg=UBI_VERSION=c9s \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				--build-arg=CUDA="cuda-" \
				-t runtime-images:cuda-minimal-c9s-py39_${RELEASE}_${DATE} .
