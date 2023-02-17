.PHONY: default ubi9-py39 cuda-ubi9-py39

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')

default:
	@echo "Options are:"
	@echo "Standard images:"
	@echo "c9s-py39 : builds an image based on CentOS Stream 9 with Python 3.9"
	@echo ""
	@echo "CUDA images:"
	@echo "cuda-c9s-py39 : builds an image based on CentOS Stream 9 with Python 3.9"
	@echo "---"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

c9s-py39:
	cd container && podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=runtime-images:minimal-c9s-py39_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=c9s \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				--build-arg=CUDA="" \
				-t runtime-images:r-c9s-py39_${RELEASE}_${DATE} .

cuda-c9s-py39:
	cd container && podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=runtime-images:cuda-minimal-c9s-py39_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=c9s \
				--build-arg=PYTHON_VERSION=py39 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.9" \
				--build-arg=CUDA="cuda-" \
				-t runtime-images:cuda-r-c9s-py39_${RELEASE}_${DATE} .
