ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="runtime-images:${CUDA}monai-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Data Science runtime + Monai with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Data Science runtime + Monai with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Data Science + Monai with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Data Science runtime + Monai with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/guimou/runtime-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/guimou/runtime-images/jupyter/monai" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/runtime-images:${CUDA}monai-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

USER 0

RUN yum install -y yum-utils && \
    yum-config-manager --enable crb && \
    yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    INSTALL_PKGS="opencv opencv-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

USER 1001

####################
# Monai            #
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

