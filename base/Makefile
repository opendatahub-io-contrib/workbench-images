.PHONY: default ubi8-py38 ubi9-py39 c9s-py39 validate-py39 validate-py38

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')
REQUIRED_RUNTIME_IMAGE_COMMANDS ?= "curl python oc"

default:
	@echo "Options are:"
	@echo "ubi9-py39 : builds an image based on UBI9 with Python 3.9"
	@echo "c9s-py39 : builds an image based on CentOS Stream 9 with Python 3.9"
	@echo "ubi8-py38 : builds an image based on UBI8 with Python 3.8"
	@echo "---"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

ubi9-py39:
	cd ubi9 && podman build --build-arg=RELEASE=${RELEASE} \
							--build-arg=DATE=${DATE} \
							-t workbench-images:base-ubi9-py39_${RELEASE}_${DATE} .

c9s-py39:
	cd c9s && podman build --build-arg=RELEASE=${RELEASE} \
							--build-arg=DATE=${DATE} \
							-t workbench-images:base-c9s-py39_${RELEASE}_${DATE} .

ubi8-py38:
	cd ubi8 && podman build --build-arg=RELEASE=${RELEASE} \
							--build-arg=DATE=${DATE} \
							-t workbench-images:base-ubi8-py38_${RELEASE}_${DATE} .


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
