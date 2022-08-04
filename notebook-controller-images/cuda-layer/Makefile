.PHONY: default ubi9-py39 c9s-py39 ubi8-py38 

TAG ?= $(shell git describe --tags --always --dirty)

default:
	@echo "Options are:"
	@echo "ubi9-py39 : builds all CUDA images for the ubi9-py39 family"
	@echo "c9s-py39 : builds all CUDA images for the c9s-py39 family"
	@echo "ubi8-py38 : builds all CUDA images for the ubi8-py38 family"
	@echo "---"
	@echo "Please specify the BASE image with BASE_IMAGE= and the images tags with TAG=..."
	@echo "(all images in the chain will have the same version number)"

ubi8-py38:
	cd base && podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} -t s2i-base-ubi8-py38-cuda-base:${TAG} .
	cd runtime && podman build --build-arg=BASE_IMAGE=s2i-base-ubi8-py38-cuda-base:${TAG} -t s2i-base-ubi8-py38-cuda-runtime:${TAG} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-ubi8-py38-cuda-runtime:${TAG} -t s2i-base-ubi8-py38-cuda-runtime-cudnn:${TAG} .
	cd devel && podman build --build-arg=BASE_IMAGE=s2i-base-ubi8-py38-cuda-runtime:${TAG} -t s2i-base-ubi8-py38-cuda-devel:${TAG} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-ubi8-py38-cuda-devel:${TAG} -t s2i-base-ubi8-py38-cuda-devel-cudnn:${TAG} .
# Add "fake" build to get back to main tree (cuda image = runtime+cudnn)
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-ubi8-py38-cuda-runtime:${TAG} -t s2i-base-cuda-ubi8-py38:${TAG} .

ubi9-py39:
	cd base && podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} -t s2i-base-ubi9-py39-cuda-base:${TAG} .
	cd runtime && podman build --build-arg=BASE_IMAGE=s2i-base-ubi9-py39-cuda-base:${TAG} -t s2i-base-ubi9-py39-cuda-runtime:${TAG} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-ubi9-py39-cuda-runtime:${TAG} -t s2i-base-ubi9-py39-cuda-runtime-cudnn:${TAG} .
	cd devel && podman build --build-arg=BASE_IMAGE=s2i-base-ubi9-py39-cuda-runtime:${TAG} -t s2i-base-ubi9-py39-cuda-devel:${TAG} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-ubi9-py39-cuda-devel:${TAG} -t s2i-base-ubi9-py39-cuda-devel-cudnn:${TAG} .
# Add "fake" build to get back to main tree (cuda image = runtime+cudnn)
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-ubi9-py39-cuda-runtime:${TAG} -t s2i-base-cuda-ubi9-py39:${TAG} .

c9s-py39:
	cd base && podman build --build-arg=BASE_IMAGE=${BASE_IMAGE} -t s2i-base-c9s-py39-cuda-base:${TAG} .
	cd runtime && podman build --build-arg=BASE_IMAGE=s2i-base-c9s-py39-cuda-base:${TAG} -t s2i-base-c9s-py39-cuda-runtime:${TAG} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-c9s-py39-cuda-runtime:${TAG} -t s2i-base-c9s-py39-cuda-runtime-cudnn:${TAG} .
	cd devel && podman build --build-arg=BASE_IMAGE=s2i-base-c9s-py39-cuda-runtime:${TAG} -t s2i-base-c9s-py39-cuda-devel:${TAG} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-c9s-py39-cuda-devel:${TAG} -t s2i-base-c9s-py39-cuda-devel-cudnn:${TAG} .
# Add "fake" build to get back to main tree (cuda image = runtime+cudnn)
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=s2i-base-c9s-py39-cuda-runtime:${TAG} -t s2i-base-cuda-c9s-py39:${TAG} .