.PHONY: default ubi8-py38 cuda-ubi8-py38

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')
REQUIRED_RUNTIME_IMAGE_COMMANDS ?= "curl python oc"

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
				--build-arg=BASE_IMAGE=workbench-images:base-ubi8-py38_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=ubi8 \
				--build-arg=PYTHON_VERSION=py38 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.8" \
				--build-arg=CUDA="" \
				-t workbench-images:jupyter-minimal-ubi8-py38_${RELEASE}_${DATE} .

cuda-ubi8-py38:
	podman build --build-arg=RELEASE=${RELEASE} \
				--build-arg=DATE=${DATE} \
				--build-arg=BASE_IMAGE=workbench-images:cuda-base-ubi8-py38_${RELEASE}_${DATE} \
				--build-arg=UBI_VERSION=ubi8 \
				--build-arg=PYTHON_VERSION=py38 \
				--build-arg=PYTHON_VERSION_LONG="Python 3.8" \
				--build-arg=CUDA="cuda-" \
				-t workbench-images:cuda-jupyter-minimal-ubi8-py38_${RELEASE}_${DATE} .

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
	echo "=> Checking for ability to run notebook..." ; \
	podman run --rm --entrypoint /bin/bash $$IMAGE -c "python -m pip install papermill && \
		python -m papermill /opt/app-root/bin/utils/test_notebook.ipynb output.ipynb > /dev/null" ; \
	if [ $$? -ne 0 ]; then \
		echo "ERROR: Image $$IMAGE cannot run test notebook" ; \
		fail=1; \
	fi; \
	echo "=> Checking for Jupyter ability to start..." ; \
	podman run -d --network=host --name validation-container $$IMAGE ; \
	for i in {1..6}; do \
		nc -z localhost 8888 && break || sleep 5; \
	done; \
	nc -z localhost 8888 ; \
	if [ $$? -ne 0 ]; then \
		echo "ERROR: Image $$IMAGE cannot start Jupyter" ; \
		fail=1; \
	else \
		echo "Checking Jupyter endpoint" ; \
		curl -s http://0.0.0.0:8888/api -o /dev/null ; \
		if [ $$? -ne 0 ]; then \
			echo "ERROR: Jupyter does not answer" ; \
			fail=1; \
		fi; \
	fi; \
	echo "Removing container" ; \
	podman stop validation-container && podman rm validation-container ; \
	echo "-----------------------------------------------------------" ; \
	if [ $$fail -eq 1 ]; then \
		echo "=> ERROR: Container image $$IMAGE failed to validate" ; \
		exit 1 ; \
	else \
		echo "=> Container image $$IMAGE validated" ; \
	fi; \
