ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="runtime-images:${CUDA}minimal-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Minimal runtime image with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Minimal runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Minimal runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Minimal runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/guimou/runtime-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/guimou/runtime-images/jupyter/minimal" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/runtime-images:${CUDA}minimal-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

####################
# Minimal notebook #
####################

WORKDIR /opt/app-root/bin

COPY Pipfile.lock ./

# Install packages and cleanup
# (all commands are chained to minimize layer size)
RUN echo "Installing softwares and packages" && \
    # Install Python packages \
    micropipenv install && \
    rm -f ./Pipfile.lock && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.8/site-packages && \
    fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src
