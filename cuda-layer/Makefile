.PHONY: default ubi9-py39 c9s-py39 ubi8-py38 validate-py39 validate-py38

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')

default:
	@echo "Options are:"
	@echo "ubi9-py39 : builds all CUDA images for the ubi9-py39 family"
	@echo "c9s-py39 : builds all CUDA images for the c9s-py39 family"
	@echo "ubi8-py38 : builds all CUDA images for the ubi8-py38 family"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

ubi8-py38:
	cd base && podman build --build-arg=BASE_IMAGE=workbench-images:base-ubi8-py38_${RELEASE}_${DATE} -t workbench-images:cuda-ubi8-py38_${RELEASE}_${DATE} .
	cd runtime && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi8-py38_${RELEASE}_${DATE} -t workbench-images:cuda-ubi8-py38-runtime_${RELEASE}_${DATE} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi8-py38-runtime_${RELEASE}_${DATE} -t workbench-images:cuda-ubi8-py38-runtime-cudnn_${RELEASE}_${DATE} .
	cd devel && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi8-py38_${RELEASE}_${DATE} -t workbench-images:cuda-ubi8-py38-devel_${RELEASE}_${DATE} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi8-py38-devel_${RELEASE}_${DATE} -t workbench-images:cuda-ubi8-py38-devel-cudnn_${RELEASE}_${DATE} .
# Add tag to simplify naming in the main tree, using runtime-cudnn for base cuda image
	podman tag workbench-images:cuda-ubi8-py38-runtime-cudnn_${RELEASE}_${DATE} workbench-images:cuda-base-ubi8-py38_${RELEASE}_${DATE}

ubi9-py39:
	cd base && podman build --build-arg=BASE_IMAGE=workbench-images:base-ubi9-py39_${RELEASE}_${DATE} -t workbench-images:cuda-ubi9-py39_${RELEASE}_${DATE} .
	cd runtime && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi9-py39_${RELEASE}_${DATE} -t workbench-images:cuda-ubi9-py39-runtime_${RELEASE}_${DATE} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi9-py39-runtime_${RELEASE}_${DATE} -t workbench-images:cuda-ubi9-py39-runtime-cudnn_${RELEASE}_${DATE} .
	cd devel && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi9-py39_${RELEASE}_${DATE} -t workbench-images:cuda-ubi9-py39-devel_${RELEASE}_${DATE} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-ubi9-py39-devel_${RELEASE}_${DATE} -t workbench-images:cuda-ubi9-py39-devel-cudnn_${RELEASE}_${DATE} .
# Add tag to simplify naming in the main tree, using runtime-cudnn for base cuda image
	podman tag workbench-images:cuda-ubi9-py39-runtime-cudnn_${RELEASE}_${DATE} workbench-images:cuda-base-ubi9-py39_${RELEASE}_${DATE}

c9s-py39:
	cd base && podman build --build-arg=BASE_IMAGE=workbench-images:base-c9s-py39_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39_${RELEASE}_${DATE} .
	cd runtime && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-runtime_${RELEASE}_${DATE} .
	cd runtime/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39-runtime_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-runtime-cudnn_${RELEASE}_${DATE} .
	cd devel && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-devel_${RELEASE}_${DATE} .
	cd devel/cudnn8 && podman build --build-arg=BASE_IMAGE=workbench-images:cuda-c9s-py39-devel_${RELEASE}_${DATE} -t workbench-images:cuda-c9s-py39-devel-cudnn_${RELEASE}_${DATE} .
# Add tag to simplify naming in the main tree, using runtime-cudnn for base cuda image
	podman tag workbench-images:cuda-c9s-py39-runtime-cudnn_${RELEASE}_${DATE} workbench-images:cuda-base-c9s-py39_${RELEASE}_${DATE}

validate-py39:
	@required_commands=$(REQUIRED_RUNTIME_IMAGE_COMMANDS) ; \
	if [[ $$IMAGE == "" ]] ; then \
		echo "Usage: make validate-py39 IMAGE=<container-image-name>" ; \
		exit 1 ; \
	fi ; \
	fail=0; \
	echo "-----------------------------------------------------------" ; \
	echo "Validating container image $$IMAGE" ; \
	echo "-----------------------------------------------------------" ; \
	echo "=> Loading container image ..." ; \
	podman inspect $$IMAGE > /dev/null 2>&1 ; \
	if [ $$? -ne 0 ]; then \
		echo "Container image $$IMAGE is not present or failing" ; \
		exit 1; \
	fi; \
	for cmd in $$required_commands ; do \
        echo "=> Checking container image $$IMAGE for $$cmd..." ; \
		podman run --rm  --entrypoint /bin/bash $$IMAGE -c "which $$cmd  > /dev/null 2>&1 " ; \
		if [ $$? -ne 0 ]; then \
			echo "ERROR: Container image $$IMAGE does not meet criteria for command: $$cmd" ; \
			fail=1; \
			continue; \
		fi; \
		if [ $$cmd == "python" ]; then \
			echo "=> Checking Python version..." ; \
			IMAGE_PYTHON3_MINOR_VERSION=`podman run --rm  --entrypoint /bin/bash $$IMAGE -c "$$cmd --version | cut -d' ' -f2 | cut -d'.' -f2"` ; \
			if [[ $$IMAGE_PYTHON3_MINOR_VERSION -ne 9 ]]; then \
				echo "ERROR: Container image $$IMAGE: unable to parse Python version or wrong version" ; \
				fail=1; \
			fi; \
		fi; \
	done ; \
	echo "-----------------------------------------------------------" ; \
	if [ $$fail -eq 1 ]; then \
		echo "=> ERROR: Container image $$IMAGE failed to validate" ; \
		exit 1 ; \
	else \
		echo "=> Container image $$IMAGE validated" ; \
	fi; \

validate-py38:
	@required_commands=$(REQUIRED_RUNTIME_IMAGE_COMMANDS) ; \
	if [[ $$IMAGE == "" ]] ; then \
		echo "Usage: make validate-py38 IMAGE=<container-image-name>" ; \
		exit 1 ; \
	fi ; \
	fail=0; \
	echo "-----------------------------------------------------------" ; \
	echo "Validating container image $$IMAGE" ; \
	echo "-----------------------------------------------------------" ; \
	echo "=> Loading container image ..." ; \
	podman inspect $$IMAGE > /dev/null 2>&1 ; \
	if [ $$? -ne 0 ]; then \
		echo "Container image $$IMAGE is not present or failing" ; \
		exit 1; \
	fi; \
	for cmd in $$required_commands ; do \
        echo "=> Checking container image $$IMAGE for $$cmd..." ; \
		podman run --rm  --entrypoint /bin/bash $$IMAGE -c "which $$cmd  > /dev/null 2>&1 " ; \
		if [ $$? -ne 0 ]; then \
			echo "ERROR: Container image $$IMAGE does not meet criteria for command: $$cmd" ; \
			fail=1; \
			continue; \
		fi; \
		if [ $$cmd == "python" ]; then \
			echo "=> Checking Python version..." ; \
			IMAGE_PYTHON3_MINOR_VERSION=`podman run --rm  --entrypoint /bin/bash $$IMAGE -c "$$cmd --version | cut -d' ' -f2 | cut -d'.' -f2"` ; \
			if [[ $$IMAGE_PYTHON3_MINOR_VERSION -ne 8 ]]; then \
				echo "ERROR: Container image $$IMAGE: unable to parse Python version or wrong version" ; \
				fail=1; \
			fi; \
		fi; \
	done ; \
	echo "-----------------------------------------------------------" ; \
	if [ $$fail -eq 1 ]; then \
		echo "=> ERROR: Container image $$IMAGE failed to validate" ; \
		exit 1 ; \
	else \
		echo "=> Container image $$IMAGE validated" ; \
	fi; \
