ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG CODESERVER_VERSION=v4.5.1

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG

LABEL name="s2i-code-server-${UBI_VERSION}-${PYTHON_VERSION}:latest" \
    summary="S2I Code-Server with ${PYTHON_VERSION_LONG} image based on ${UBI_VERSION}" \
    description="Code-Server notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.description="Code-Server notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.display-name="S2I Code-Server notebook with ${PYTHON_VERSION_LONG} ${UBI_VERSION} image" \
    authoritative-source-url="https://github.com/guimou/custom-notebooks" \
    io.openshift.s2i.build.commit.ref="main" \
    io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks/notebook-controller-images/s2i-code-server" \
    io.openshift.s2i.build.image="https://quay.io/guimou/s2i-code-server-${UBI_VERSION}-${PYTHON_VERSION}"

####################
# CodeServer       #
####################

USER 0

WORKDIR /tmp

RUN yum install -y "https://github.com/coder/code-server/releases/download/${CODESERVER_VERSION}/code-server-${CODESERVER_VERSION/v/}-amd64.rpm" && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

COPY run-code-server.sh /opt/app-root/bin/

ENV SHELL /bin/bash

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/run-code-server.sh
