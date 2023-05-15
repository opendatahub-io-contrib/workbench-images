ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG CODESERVER_VERSION=v4.12.0

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
    authoritative-source-url="https://github.com/opendatahub-io-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-io-contrib/workbench-images/code-server" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:${CUDA}code-server-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

####################
# CodeServer       #
####################

USER 0

WORKDIR /opt/app-root/bin

RUN yum install -y "https://github.com/coder/code-server/releases/download/${CODESERVER_VERSION}/code-server-${CODESERVER_VERSION/v/}-amd64.rpm" && \
    yum -y clean all --enablerepo='*'

####################
# Julia            #
####################

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz && \
    tar zxvf julia-1.9.0-linux-x86_64.tar.gz && \
    rm julia-1.9.0-linux-x86_64.tar.gz

ENV PATH="$PATH:/opt/app-root/bin/julia-1.9.0/bin"

#######################################################
# Install NGINX to proxy VSCode and pass probes check #
#######################################################
ENV NGINX_VERSION=1.20 \
    NGINX_SHORT_VER=120 \
    NGINX_CONFIGURATION_PATH=${APP_ROOT}/etc/nginx.d \
    NGINX_CONF_PATH=/etc/nginx/nginx.conf \
    NGINX_DEFAULT_CONF_PATH=${APP_ROOT}/etc/nginx.default.d \
    NGINX_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/nginx \
    NGINX_APP_ROOT=${APP_ROOT} \
    NGINX_LOG_PATH=/var/log/nginx \
    NGINX_PERL_MODULE_PATH=${APP_ROOT}/etc/perl

# Modules does not exist
RUN yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    INSTALL_PKGS="nss_wrapper bind-utils gettext hostname nginx nginx-mod-stream nginx-mod-http-perl fcgiwrap initscripts chkconfig" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    nginx -v 2>&1 | grep -qe "nginx/$NGINX_VERSION\." && echo "Found VERSION $NGINX_VERSION" && \
    # spawn-fcgi is not in epel9
    rpm -i --nodocs https://www.rpmfind.net/linux/fedora/linux/releases/34/Everything/x86_64/os/Packages/s/spawn-fcgi-1.6.3-20.fc34.x86_64.rpm && \
    yum -y clean all --enablerepo='*'

# Copy extra files to the image.
COPY nginx/root/ /

# Changing ownership and user rights to support following use-cases:
# 1) running container on OpenShift, whose default security model
#    is to run the container under random UID, but GID=0
# 2) for working root-less container with UID=1001, which does not have
#    to have GID=0
# 3) for default use-case, that is running container directly on operating system,
#    with default UID and GID (1001:0)
# Supported combinations of UID:GID are thus following:
# UID=1001 && GID=0
# UID=<any>&& GID=0
# UID=1001 && GID=<any>
RUN sed -i -f ${NGINX_APP_ROOT}/nginxconf.sed ${NGINX_CONF_PATH} && \
    mkdir -p ${NGINX_APP_ROOT}/etc/nginx.d/ && \
    mkdir -p ${NGINX_APP_ROOT}/etc/nginx.default.d/ && \
    mkdir -p ${NGINX_APP_ROOT}/api/ && \
    mkdir -p ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    mkdir -p ${NGINX_LOG_PATH} && \
    mkdir -p ${NGINX_PERL_MODULE_PATH} && \
    chown -R 1001:0 ${NGINX_CONF_PATH} && \
    chown -R 1001:0 ${NGINX_APP_ROOT}/etc && \
    chown -R 1001:0 ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    chown -R 1001:0 /var/lib/nginx /var/log/nginx /run && \
    chmod    ug+rw  ${NGINX_CONF_PATH} && \
    chmod -R ug+rwX ${NGINX_APP_ROOT}/etc && \
    chmod -R ug+rwX ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    chmod -R ug+rwX /var/lib/nginx /var/log/nginx /run && \
    rpm-file-permissions

## Configure nginx
COPY nginx/serverconf/ /opt/app-root/etc/nginx.default.d/
COPY nginx/httpconf/ /opt/app-root/etc/nginx.d/
COPY nginx/api/ /opt/app-root/api/


# Launcher
COPY utils utils/
COPY run-code-server.sh run-nginx.sh ./

ENV SHELL /bin/bash

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/run-code-server.sh
