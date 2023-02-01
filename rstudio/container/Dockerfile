ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="workbench-images:${CUDA}rstudio-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Rstudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Rstudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Rstudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Rstudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/opendatahub-io-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-io-contrib/workbench-images/rstudio" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:${CUDA}rstudio-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

####################
# RStudio          #
####################

USER 0

# R needs the CUDA toolkit and special flags to build Tensorflow and other packages
RUN if [ "$CUDA" = "cuda-" ] ; then \
        yum -y install cuda-toolkit-11-8 && \
        yum -y clean all  --enablerepo='*'; \
    fi
ENV XLA_FLAGS=--xla_gpu_cuda_data_dir=/usr/local/cuda

ENV R_VERSION=4.2.2

# Install R
RUN yum install -y yum-utils && \
    yum-config-manager --enable crb && \
    yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    INSTALL_PKGS="R-core R-core-devel R-java R-Rcpp R-highlight \
    R-littler R-littler-examples openssl-libs compat-openssl11" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/lib64/R/etc/Rprofile.site && \
    (umask 002;touch /usr/lib64/R/etc/Renviron.site) && \
    yum -y clean all --enablerepo='*'

# set R library to default (used in install.r from littler)
ENV LIBLOC /usr/lib64/R/library

# set User R Library path
ENV R_LIBS_USER /opt/app-root/src/Rpackages/4.2

WORKDIR /tmp/

# Install RStudio
RUN wget https://download2.rstudio.org/server/rhel8/x86_64/rstudio-server-rhel-2022.07.2-576-x86_64.rpm && \
    yum install -y rstudio-server-rhel-2022.07.2-576-x86_64.rpm && \
    rm rstudio-server-rhel-2022.07.2-576-x86_64.rpm && \
    yum -y clean all  --enablerepo='*'

# Specific RStudio config and fixes
RUN chmod 1777 /var/run/rstudio-server && \
    mkdir -p /usr/share/doc/R
COPY rsession.conf /etc/rstudio/rsession.conf
ENV RSTUDIO_USER_IDENTITY_DISPLAY=rstudio

########################################################
# Install NGINX to proxy RStudio and pass probes check #
########################################################
ENV NGINX_VERSION=1.22 \
    NGINX_SHORT_VER=122 \
    NGINX_CONFIGURATION_PATH=${APP_ROOT}/etc/nginx.d \
    NGINX_CONF_PATH=/etc/nginx/nginx.conf \
    NGINX_DEFAULT_CONF_PATH=${APP_ROOT}/etc/nginx.default.d \
    NGINX_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/nginx \
    NGINX_APP_ROOT=${APP_ROOT} \
    NGINX_LOG_PATH=/var/log/nginx \
    NGINX_PERL_MODULE_PATH=${APP_ROOT}/etc/perl

# Modules does not exist
RUN yum -y module enable nginx:$NGINX_VERSION && \
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
WORKDIR /opt/app-root/bin

COPY utils utils/
COPY run-rstudio.sh setup_rstudio.py rsession.sh run-nginx.sh ./

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/run-rstudio.sh
