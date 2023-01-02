ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG CODESERVER_VERSION=v4.9.0

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="workbench-images:${CUDA}datascience-code-server-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Data Science + VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Data Science + VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Data Science + VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Data Science + VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/opendatahub-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-contrib/workbench-images/jupyter/datascience-code-server" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:${CUDA}datascience-code-server-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

####################
# CodeServer       #
####################

USER 0

WORKDIR /opt/app-root/bin

RUN yum install -y "https://github.com/coder/code-server/releases/download/${CODESERVER_VERSION}/code-server-${CODESERVER_VERSION/v/}-amd64.rpm" && \
    yum -y clean all --enablerepo='*'

USER 1001

COPY checkbash.sh ./
COPY --chown=default:root ./jupyter-vscode-proxy ./jupyter-vscode-proxy

# Install launcher package and cleanup
RUN pip install --no-cache-dir ./jupyter-vscode-proxy && \
    rm -rf ./jupyter-vscode-proxy && \
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P

ENV SHELL /usr/bin/bash

WORKDIR /opt/app-root/src

ENTRYPOINT ["/bin/sh", "-c" , "checkbash.sh && start-notebook.sh"]
