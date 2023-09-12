.PHONY: default c9s-py39 validate-py39

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')
BASE_IMAGE_PY39 ?= workbench-images:base-c9s-py39_${RELEASE}_${DATE}
IMAGE_PY39 := workbench-images:cuda-c9s-py39-runtime-cudnn_${RELEASE}_${DATE}
BASE_IMAGE_PY311 ?= workbench-images:base-c9s-py311_${RELEASE}_${DATE}
IMAGE_PY311 := workbench-images:cuda-c9s-py311-runtime-cudnn_${RELEASE}_${DATE}
REQUIRED_RUNTIME_IMAGE_COMMANDS ?= "curl python oc"

default:
	@echo "Options are:"
	@echo "all: builds and validates all CUDA images based on CentOS Stream 9 with Python 3.9 or 3.11"
	@echo "c9s-py39 : builds the image"
	@echo "validate-py39 : validates the image"
	@echo "c9s-py311 : builds the image"
	@echo "validate-py311 : validates the image"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

all: c9s-py39 validate-py39 c9s-py311 validate-py311

c9s-py39:
	cd base && podman build --build-arg=BASE_IMAGE=${BASE_IMAGE_PY39} -t workbench-images:cuda-c9s-py39-chainbase_${RELEASE}_${DATE} .
	cd runtime && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39-chainbase_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-runtime_${RELEASE}_${DATE} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39-runtime_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-runtime-cudnn_${RELEASE}_${DATE} .
	cd devel && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39-runtime_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-devel_${RELEASE}_${DATE} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39-devel_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-devel-cudnn_${RELEASE}_${DATE} .

c9s-py311:
	cd base && podman build --build-arg=BASE_IMAGE=${BASE_IMAGE_PY311} -t workbench-images:cuda-c9s-py311-chainbase_${RELEASE}_${DATE} .
	cd runtime && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py311-chainbase_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py311-runtime_${RELEASE}_${DATE} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py311-runtime_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py311-runtime-cudnn_${RELEASE}_${DATE} .
	cd devel && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py311-runtime_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py311-devel_${RELEASE}_${DATE} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py311-devel_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py311-devel-cudnn_${RELEASE}_${DATE} .

validate-py39:
	@required_commands=$(REQUIRED_RUNTIME_IMAGE_COMMANDS) ; \
	if [[ $(IMAGE_PY39) == "" ]] ; then \
		echo "Usage: make validate-py39 RELEASE=... DATE=..." ; \
		exit 1 ; \
	fi ; \
	fail=0; \
	echo "-----------------------------------------------------------" ; \
	echo "Validating container image $(IMAGE_PY39)" ; \
	echo "-----------------------------------------------------------" ; \
	echo "=> Loading container image ..." ; \
	podman inspect localhost/$(IMAGE_PY39) > /dev/null 2>&1 ; \
	if [ $$? -ne 0 ]; then \
		echo "Container image $(IMAGE_PY39) is not present or failing" ; \
		exit 1; \
	fi; \
	for cmd in $$required_commands ; do \
        echo "=> Checking container image $(IMAGE_PY39) for $$cmd..." ; \
		podman run --rm  --entrypoint /bin/bash localhost/$(IMAGE_PY39) -c "which $$cmd  > /dev/null 2>&1 " ; \
		if [ $$? -ne 0 ]; then \
			echo "ERROR: Container image $(IMAGE_PY39) does not meet criteria for command: $$cmd" ; \
			fail=1; \
			continue; \
		fi; \
		if [ $$cmd == "python" ]; then \
			echo "=> Checking Python version..." ; \
			IMAGE_PYTHON3_MINOR_VERSION=`podman run --rm  --entrypoint /bin/bash $(IMAGE_PY39) -c "$$cmd --version | cut -d' ' -f2 | cut -d'.' -f2"` ; \
			if [[ $$IMAGE_PYTHON3_MINOR_VERSION -ne 9 ]]; then \
				echo "ERROR: Container image $(IMAGE_PY39): unable to parse Python version or wrong version" ; \
				fail=1; \
			fi; \
		fi; \
	done ; \
	echo "-----------------------------------------------------------" ; \
	if [ $$fail -eq 1 ]; then \
		echo "=> ERROR: Container image $(IMAGE_PY39) failed to validate" ; \
		exit 1 ; \
	else \
		echo "=> Container image $(IMAGE_PY39) validated" ; \
	fi; \

validate-py311:
	@required_commands=$(REQUIRED_RUNTIME_IMAGE_COMMANDS) ; \
	if [[ $(IMAGE_PY311) == "" ]] ; then \
		echo "Usage: make validate-py39 RELEASE=... DATE=..." ; \
		exit 1 ; \
	fi ; \
	fail=0; \
	echo "-----------------------------------------------------------" ; \
	echo "Validating container image $(IMAGE_PY311)" ; \
	echo "-----------------------------------------------------------" ; \
	echo "=> Loading container image ..." ; \
	podman inspect localhost/$(IMAGE_PY311) > /dev/null 2>&1 ; \
	if [ $$? -ne 0 ]; then \
		echo "Container image $(IMAGE_PY311) is not present or failing" ; \
		exit 1; \
	fi; \
	for cmd in $$required_commands ; do \
        echo "=> Checking container image $(IMAGE_PY311) for $$cmd..." ; \
		podman run --rm  --entrypoint /bin/bash localhost/$(IMAGE_PY311) -c "which $$cmd  > /dev/null 2>&1 " ; \
		if [ $$? -ne 0 ]; then \
			echo "ERROR: Container image $(IMAGE_PY311) does not meet criteria for command: $$cmd" ; \
			fail=1; \
			continue; \
		fi; \
		if [ $$cmd == "python" ]; then \
			echo "=> Checking Python version..." ; \
			IMAGE_PYTHON3_MINOR_VERSION=`podman run --rm  --entrypoint /bin/bash $(IMAGE_PY311) -c "$$cmd --version | cut -d' ' -f2 | cut -d'.' -f2"` ; \
			if [[ $$IMAGE_PYTHON3_MINOR_VERSION -ne 11 ]]; then \
				echo "ERROR: Container image $(IMAGE_PY311): unable to parse Python version or wrong version" ; \
				fail=1; \
			fi; \
		fi; \
	done ; \
	echo "-----------------------------------------------------------" ; \
	if [ $$fail -eq 1 ]; then \
		echo "=> ERROR: Container image $(IMAGE_PY311) failed to validate" ; \
		exit 1 ; \
	else \
		echo "=> Container image $(IMAGE_PY311) validated" ; \
	fi; \
