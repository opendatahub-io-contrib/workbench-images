.PHONY: default ubi8-py38 ubi9-py39 c9s-py39 all build-all refresh-pipfile-lock

RELEASE ?= $(shell git describe --tags --always --dirty || echo 'dev')
DATE ?= $(shell date +'%Y%m%d')
REPO ?= quay.io/opendatahub-contrib/workbench-images

default:
	@echo "This Makefile builds base, minimal-notebook and datascience-notebook images"
	@echo "and their CUDA versions for different platforms."
	@echo "It also builds Datascience + VSCode or RStudio as well as their standalone versions"
	@echo "Options are:"
	@echo "all : builds and pushed all flavors of images"
	@echo "refresh-pipfile-lock : only refreshes the various Pipfile.lock"
	@echo "ubi9-py39 : builds images based on UBI9 with Python 3.9"
	@echo "c9s-py39 : builds images based on CentOS Stream 9 with Python 3.9"
	@echo "ubi8-py38 : builds images based on UBI8 with Python 3.8"
	@echo "push-all : push all images"
	@echo "push-ubi9-py39 : push images based on UBI9 with Python 3.9"
	@echo "push-c9s-py39 : push images based on CentOS Stream 9 with Python 3.9"
	@echo "push-ubi8-py38 : push images based on UBI8 with Python 3.8"
	@echo "---"
	@echo "Please specify:"
	@echo " - the release number with RELEASE=... (defaults to git tag or 'dev')"
	@echo " - the build date with DATE=... (defaults to current date)"
	@echo " - the reepository to push to with REPO=... (defaults to 'quay.io/opendatahub-contrib/workbench-images')"

all: refresh-pipfile-lock build-all push-all

build-all: ubi9-py39 c9s-py39 ubi8-py38

# Refreshes all pipfile.lock files
refresh-pipfile-lock:
	cd base/c9s && pipenv lock
	cd base/ubi8 && pipenv lock
	cd base/ubi9 && pipenv lock
	cd jupyter/minimal/py38 && pipenv lock
	cd jupyter/minimal/py39 && pipenv lock
	cd jupyter/datascience/py38 && pipenv lock
	cd jupyter/datascience/py39 && pipenv lock
	cd jupyter/monai/container && pipenv lock
	cd jupyter/optapy/container && pipenv lock

ubi9-py39:
	cd base && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:base-ubi9-py39_${RELEASE}_${DATE}
	cd cuda-layer && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-base-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/minimal/py39 && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-minimal-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/minimal/py39 && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-jupyter-minimal-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/datascience/py39 && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-datascience-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/datascience/py39 && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-jupyter-datascience-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/datascience-code-server && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/datascience-code-server && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/spark && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-spark-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/spark && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-jupyter-spark-ubi9-py39_${RELEASE}_${DATE}
	cd jupyter/optapy && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-optapy-ubi9-py39_${RELEASE}_${DATE}
	cd code-server && make ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:code-server-ubi9-py39_${RELEASE}_${DATE}
	cd code-server && make cuda-ubi9-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-code-server-ubi9-py39_${RELEASE}_${DATE}
	
c9s-py39:
	cd base && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:base-c9s-py39_${RELEASE}_${DATE}
	cd cuda-layer && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-base-c9s-py39_${RELEASE}_${DATE}
	cd jupyter/minimal/py39 && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-minimal-c9s-py39_${RELEASE}_${DATE}
	cd jupyter/minimal/py39 && make cuda-c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-jupyter-minimal-c9s-py39_${RELEASE}_${DATE}
	cd jupyter/datascience/py39 && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-datascience-c9s-py39_${RELEASE}_${DATE}
	cd jupyter/datascience/py39 && make cuda-c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-jupyter-datascience-c9s-py39_${RELEASE}_${DATE}
	cd jupyter/datascience-rstudio && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE}
	cd jupyter/datascience-rstudio && make cuda-c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE}
	cd jupyter/monai && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:jupyter-monai-c9s-py39_${RELEASE}_${DATE}
	cd rstudio && make c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:rstudio-c9s-py39_${RELEASE}_${DATE}
	cd rstudio && make cuda-c9s-py39 RELEASE=${RELEASE} DATE=${DATE} && make validate-py39 IMAGE=workbench-images:cuda-rstudio-c9s-py39_${RELEASE}_${DATE}

ubi8-py38:
	cd base && make ubi8-py38 RELEASE=${RELEASE} DATE=${DATE} && make validate-py38 IMAGE=workbench-images:base-ubi8-py38_${RELEASE}_${DATE}
	cd cuda-layer && make ubi8-py38 RELEASE=${RELEASE} DATE=${DATE} && make validate-py38 IMAGE=workbench-images:cuda-base-ubi8-py38_${RELEASE}_${DATE}
	cd jupyter/minimal/py38 && make ubi8-py38 RELEASE=${RELEASE} DATE=${DATE} && make validate-py38 IMAGE=workbench-images:jupyter-minimal-ubi8-py38_${RELEASE}_${DATE}
	cd jupyter/minimal/py38 && make cuda-ubi8-py38 RELEASE=${RELEASE} DATE=${DATE} && make validate-py38 IMAGE=workbench-images:cuda-jupyter-minimal-ubi8-py38_${RELEASE}_${DATE}
	cd jupyter/datascience/py38 && make ubi8-py38 RELEASE=${RELEASE} DATE=${DATE} && make validate-py38 IMAGE=workbench-images:jupyter-datascience-ubi8-py38_${RELEASE}_${DATE}
	cd jupyter/datascience/py38 && make cuda-ubi8-py38 RELEASE=${RELEASE} DATE=${DATE} && make validate-py38 IMAGE=workbench-images:cuda-jupyter-datascience-ubi8-py38_${RELEASE}_${DATE}

push-all: push-ubi9-py39 push-c9s-py39 push-ubi8-py38

push-ubi9-py39:
	podman push localhost/workbench-images:base-ubi9-py39_${RELEASE}_${DATE} ${REPO}:base-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:code-server-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-base-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-base-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-code-server-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-minimal-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-spark-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi9-py39-devel_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-devel_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi9-py39-devel-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-devel-cudnn_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi9-py39-runtime_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-runtime_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi9-py39-runtime-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-runtime-cudnn_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-minimal-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-optapy-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-optapy-ubi9-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-spark-ubi9-py39_${RELEASE}_${DATE}
# Push latest tag to all new images	
	podman push localhost/workbench-images:base-ubi9-py39_${RELEASE}_${DATE} ${REPO}:base-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:code-server-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-base-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-base-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-code-server-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-code-server-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-minimal-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-spark-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi9-py39_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi9-py39-devel_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-devel_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi9-py39-devel-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-devel-cudnn_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi9-py39-runtime_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-runtime_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi9-py39-runtime-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi9-py39-runtime-cudnn_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-datascience-code-server-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-code-server-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-datascience-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-minimal-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-minimal-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-optapy-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-optapy-ubi9-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-spark-ubi9-py39_${RELEASE}_${DATE} ${REPO}:jupyter-spark-ubi9-py39_${RELEASE}_latest


push-c9s-py39:
	podman push localhost/workbench-images:base-c9s-py39_${RELEASE}_${DATE} ${REPO}:base-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-base-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-base-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-c9s-py39-devel_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-devel_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-c9s-py39-devel-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-devel-cudnn_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-c9s-py39-runtime_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-runtime_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-c9s-py39-runtime-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-runtime-cudnn_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-minimal-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-rstudio-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-minimal-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-monai-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-monai-c9s-py39_${RELEASE}_${DATE}
	podman push localhost/workbench-images:rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:rstudio-c9s-py39_${RELEASE}_${DATE}
# Push latest tag to all new images
	podman push localhost/workbench-images:base-c9s-py39_${RELEASE}_${DATE} ${REPO}:base-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-base-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-base-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-c9s-py39-devel_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-devel_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-c9s-py39-devel-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-devel-cudnn_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-c9s-py39-runtime_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-runtime_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-c9s-py39-runtime-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-c9s-py39-runtime-cudnn_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-rstudio-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-minimal-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:cuda-rstudio-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-datascience-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-datascience-rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-rstudio-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-minimal-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-minimal-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-monai-c9s-py39_${RELEASE}_${DATE} ${REPO}:jupyter-monai-c9s-py39_${RELEASE}_latest
	podman push localhost/workbench-images:rstudio-c9s-py39_${RELEASE}_${DATE} ${REPO}:rstudio-c9s-py39_${RELEASE}_latest

push-ubi8-py38:
	podman push localhost/workbench-images:base-ubi8-py38_${RELEASE}_${DATE} ${REPO}:base-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-base-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-base-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-jupyter-minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-minimal-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi8-py38-devel_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-devel_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi8-py38-devel-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-devel-cudnn_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi8-py38-runtime_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-runtime_${RELEASE}_${DATE}
	podman push localhost/workbench-images:cuda-ubi8-py38-runtime-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-runtime-cudnn_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-ubi8-py38_${RELEASE}_${DATE}
	podman push localhost/workbench-images:jupyter-minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:jupyter-minimal-ubi8-py38_${RELEASE}_${DATE}
# Push latest tag to all new images	
	podman push localhost/workbench-images:base-ubi8-py38_${RELEASE}_${DATE} ${REPO}:base-ubi8-py38_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-base-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-base-ubi8-py38_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-datascience-ubi8-py38_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-jupyter-minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-jupyter-minimal-ubi8-py38_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi8-py38_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi8-py38-devel_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-devel_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi8-py38-devel-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-devel-cudnn_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi8-py38-runtime_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-runtime_${RELEASE}_latest
	podman push localhost/workbench-images:cuda-ubi8-py38-runtime-cudnn_${RELEASE}_${DATE} ${REPO}:cuda-ubi8-py38-runtime-cudnn_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-datascience-ubi8-py38_${RELEASE}_${DATE} ${REPO}:jupyter-datascience-ubi8-py38_${RELEASE}_latest
	podman push localhost/workbench-images:jupyter-minimal-ubi8-py38_${RELEASE}_${DATE} ${REPO}:jupyter-minimal-ubi8-py38_${RELEASE}_latest
