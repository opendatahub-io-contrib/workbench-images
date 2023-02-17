ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="runtime-images:${CUDA}optapy-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Data Science runtime + Optapy with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Data Science runtime + Optapy with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Data Science runtime + Optapy with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Data Science runtime + Optapy with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/guimou/runtime-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/guimou/runtime-images/jupyter/optapy" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/runtime-images:${CUDA}optapy-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

USER 0

RUN INSTALL_PKGS="java-11-openjdk java-11-openjdk-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

USER 1001

####################
# Optapy           #
####################

WORKDIR /opt/app-root/bin/

# Copying custom packages
COPY Pipfile.lock ./

# Install packages and cleanup
# (all commands are chained to minimize layer size)
RUN echo "Installing softwares and packages" && \
    # Install Python packages \
    micropipenv install && \
    rm -f ./Pipfile.lock && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src


