ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG CODESERVER_VERSION=v4.9.0

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="workbench-images:${CUDA}code-server-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="VSCode with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/opendatahub-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-contrib/workbench-images/code-server" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:${CUDA}code-server-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

####################
# CodeServer       #
####################

USER 0

WORKDIR /opt/app-root/bin

RUN yum install -y "https://github.com/coder/code-server/releases/download/${CODESERVER_VERSION}/code-server-${CODESERVER_VERSION/v/}-amd64.rpm" && \
    yum -y clean all --enablerepo='*'

COPY utils utils/
COPY run-code-server.sh ./

ENV SHELL /bin/bash

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/run-code-server.sh
