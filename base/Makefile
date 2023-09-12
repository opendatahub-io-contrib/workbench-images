.PHONY: default all c9s-py39 validate-py39 c9s-py311 validate-py311

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')
BASE_IMAGE_PY39 ?= quay.io/sclorg/python-39-c9s:c9s
IMAGE_PY39 ?= workbench-images:base-c9s-py39_$(RELEASE)_$(DATE)
BASE_IMAGE_PY311 ?= quay.io/sclorg/python-311-c9s:c9s
IMAGE_PY311 ?= workbench-images:base-c9s-py311_$(RELEASE)_$(DATE)
REQUIRED_RUNTIME_IMAGE_COMMANDS ?= "curl python oc"

default:
	@echo "Options are:"
	@echo "all: builds and validates an image based on CentOS Stream 9 with Python 3.9"
	@echo "c9s-py39 : builds the Python 3.9 image"
	@echo "validate-py39 : validates the Python 3.9 image"
	@echo "c9s-py311 : builds the Python 3.11 image"
	@echo "validate-py311 : validates the Python 3.11 image"
	@echo "---"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to git info or 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"

all: c9s-py39 validate-py39 c9s-py311 validate-py311

c9s-py39:
	cd c9s && podman build --no-cache --build-arg=BASE_IMAGE=${BASE_IMAGE_PY39} \
							--build-arg=RELEASE=${RELEASE} \
							--build-arg=DATE=${DATE} \
							--build-arg=PYTHON_VERSION_NUMBER=3.9 \
							-t ${IMAGE_PY39} .

c9s-py311:
	cd c9s && podman build --no-cache --build-arg=BASE_IMAGE=${BASE_IMAGE_PY311} \
							--build-arg=RELEASE=${RELEASE} \
							--build-arg=DATE=${DATE} \
							--build-arg=PYTHON_VERSION_NUMBER=3.11 \
							-t ${IMAGE_PY311} .

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
		echo "Usage: make validate-py311 RELEASE=... DATE=..." ; \
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
