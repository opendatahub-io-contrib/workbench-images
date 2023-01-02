FROM registry.access.redhat.com/ubi8/python-38

ARG RELEASE
ARG DATE

LABEL name="workbench-images:base-ubi8-py38_${RELEASE}_${DATE}" \
    summary="UBI8-Python 3.8 base for workbench images" \
    description="UBI8-Python 3.8 base for workbench images" \
    io.k8s.description="UBI8-Python 3.8 base for workbench images" \
    io.k8s.display-name="UBI8-Python 3.8 base for workbench images for ODH or RHODS" \
    authoritative-source-url="https://github.com/opendatahub-io-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-io-contrib/workbench-images/jupyter/base/ubi8" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:base-ubi8-py38_${RELEASE}_${DATE}"

# This will avoid people forgetting to set no-cache-dir when building images
ENV PIP_NO_CACHE_DIR=1

USER 0

# Update base image for latest security updates
# (ubi images are not released that often)
RUN dnf -y --setopt=tsflags=nodocs update && \
    dnf -y clean all --enablerepo='*'

USER 1001

# Install micropipenv to deploy packages from Pipfile.lock
RUN pip install -U "micropipenv[toml]"

WORKDIR /opt/app-root/bin

# Copy files
COPY Pipfile.lock ./

# Install packages and cleanup
# (all commands are chained to minimize layer size)
RUN echo "Installing softwares and packages" && \
    # Install oc client \
    curl -L https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz \
        -o /tmp/openshift-client-linux.tar.gz && \
    tar -xzvf /tmp/openshift-client-linux.tar.gz oc && \
    rm -f /tmp/openshift-client-linux.tar.gz && \
    # Install Python packages \
    micropipenv install && \
    rm -f ./Pipfile.lock && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.8/site-packages && \
    fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src
