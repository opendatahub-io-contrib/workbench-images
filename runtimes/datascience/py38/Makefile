.PHONY: default ubi8-py38 cuda-ubi8-py38

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')

default:
	@echo "Options are:"
	@echo "Standard images:"
	@echo "ubi8-py38 : builds an image based on UBI8 with Python 3.8"
	@echo ""
	@echo "CUDA images:"
	@echo "cuda-ubi8-py38 : builds an image based on UBI8 with Python 3.8"
	@echo "---"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

ubi8-py38:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=runtime-images:minimal-ubi8-py38_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=ubi8 \
				--build-arg=PYTHON_VERSION=py38 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.8" \
				--build-arg=CUDA="" \
				-t runtime-images:datascience-ubi8-py38_${RELEASE}_${DATE} .

cuda-ubi8-py38:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=runtime-images:cuda-minimal-ubi8-py38_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=ubi8 \
				--build-arg=PYTHON_VERSION=py38 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.8" \
				--build-arg=CUDA="cuda-" \
				-t runtime-images:cuda-datascience-ubi8-py38_${RELEASE}_${DATE} .
