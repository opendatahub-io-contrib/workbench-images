.PHONY: default ubi9-py39 c9s-py39 cuda-ubi9-py39 cuda-c9s-py39 validate-py39

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')

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
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

ubi9-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=CUDA="" \
				--build-arg=BASE_IMAGE=runtime-images:minimal-ubi9-py39_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=ubi9 \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				-t runtime-images:datascience-ubi9-py39_${RELEASE}_${DATE} .

c9s-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=CUDA="" \
				--build-arg=BASE_IMAGE=runtime-images:minimal-c9s-py39_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=c9s \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				-t runtime-images:datascience-c9s-py39_${RELEASE}_${DATE} .

cuda-ubi9-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=CUDA="cuda-" \
				--build-arg=BASE_IMAGE=runtime-images:cuda-minimal-ubi9-py39_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=ubi9 \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				-t runtime-images:cuda-datascience-ubi9-py39_${RELEASE}_${DATE} .

cuda-c9s-py39:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=CUDA="cuda-" \
				--build-arg=BASE_IMAGE=runtime-images:cuda-minimal-c9s-py39_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=c9s \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				-t runtime-images:cuda-datascience-c9s-py39_${RELEASE}_${DATE} .
