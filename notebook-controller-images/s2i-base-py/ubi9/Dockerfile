ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG

LABEL name="s2i-base-${UBI_VERSION}-${PYTHON_VERSION}:latest" \
    summary="S2I base ${PYTHON_VERSION_LONG} image based on ${UBI_VERSION}" \
    description="Base image with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.description="Base image with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.display-name="S2I base ${PYTHON_VERSION_LONG} ${UBI_VERSION} image" \
    io.openshift.tags="python,${PYTHON_VERSION}" \
    authoritative-source-url="https://github.com/guimou/custom-notebooks" \
    io.openshift.s2i.build.commit.ref="main" \
    io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks/notebook-controller-images/s2i-base-py" \
    io.openshift.s2i.build.image="https://quay.io/guimou/s2i-base-${UBI_VERSION}-${PYTHON_VERSION}"

USER 0

# This will avoid people forgetting to set no-cache-dir when building images
ENV PIP_NO_CACHE_DIR=1

# RHEL7 base images automatically set these envvars to run scl_enable. RHEl8+
# images, however, don't as most images don't need SCLs any more. But we want
# to run it even on RHEL8+, because we set the virtualenv environment as part of
# that script
ENV BASH_ENV=${APP_ROOT}/etc/scl_enable \
    ENV=${APP_ROOT}/etc/scl_enable \
    PROMPT_COMMAND=". ${APP_ROOT}/etc/scl_enable"

# Update base image for latest security updates
# (ubi8 images are not released that often)
RUN yum -y update && \
    yum -y clean all --enablerepo='*' && \
    rm -rf /var/cache/dnf/

# Update existing packages venv and base to clear security issues in Quay
# (ubi8 images are not released that often)
RUN pip install --no-cache-dir -U pip setuptools && \
    /usr/bin/pip3 install --no-cache-dir -U pip setuptools

# Let's have micropipenv to install packages from Pipfile.lock
RUN /usr/bin/pip3 install -U "micropipenv[toml]"

# Install oc command line client for OpenShift cluster.
COPY oc-wrapper.sh /opt/app-root/bin/oc-wrapper.sh

RUN curl -s -o ${APP_ROOT}/oc.tar.gz https://mirror.openshift.com/pub/openshift-v3/clients/3.11.153/linux/oc.tar.gz && \
    tar -C /opt/app-root/bin -zxf ${APP_ROOT}/oc.tar.gz oc && \
    mv /opt/app-root/bin/oc /opt/app-root/bin/oc-3.11 && \
    rm ${APP_ROOT}/oc.tar.gz && \
    curl -s -o ${APP_ROOT}/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz&& \
    tar -C /opt/app-root/bin -zxf ${APP_ROOT}/oc.tar.gz oc && \
    mv /opt/app-root/bin/oc /opt/app-root/bin/oc-4 && \
    rm ${APP_ROOT}/oc.tar.gz && \
    ln -s /opt/app-root/bin/oc-wrapper.sh /opt/app-root/bin/oc

WORKDIR /opt/app-root/src
USER 1001
