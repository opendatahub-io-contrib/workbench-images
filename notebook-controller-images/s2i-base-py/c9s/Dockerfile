ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG COS_VERSION=c9s
ARG PYTHON_VERSION=py39
ARG PYTHON_VERSION_LONG="Python 3.9"

LABEL name="s2i-base-${COS_VERSION}-${PYTHON_VERSION}:latest" \
    summary="S2I base ${PYTHON_VERSION_LONG} image based on ${COS_VERSION}" \
    description="Base image with ${PYTHON_VERSION_LONG}, Source-to-Image from ${COS_VERSION}" \
    io.k8s.description="Base image with ${PYTHON_VERSION_LONG}, Source-to-Image from ${COS_VERSION}" \
    io.k8s.display-name="S2I base ${PYTHON_VERSION_LONG} ${COS_VERSION} image" \
    io.openshift.tags="python,${PYTHON_VERSION}" \
    authoritative-source-url="https://github.com/guimou/custom-notebooks" \
    io.openshift.s2i.build.commit.ref="main" \
    io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks/notebook-controller-images/s2i-base-py" \
    io.openshift.s2i.build.image="https://quay.io/guimou/s2i-base-${COS_VERSION}-${PYTHON_VERSION}"


USER 0

# This will avoid people forgetting to set no-cache-dir when building images
ENV PIP_NO_CACHE_DIR=1

############
# s2i core #
############
# From https://github.com/red-hat-data-services/s2i-base-container

ENV \
    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    APP_ROOT=/opt/app-root \
    # The $HOME is not set by default, but some applications needs this variable
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH} \
    PLATFORM="el9"

# This is the list of basic dependencies that all language container image can
# consume.
# Also setup the 'openshift' user that is used for the build execution and for the
# application runtime execution.
# TODO: Use better UID and GID values

RUN INSTALL_PKGS="bsdtar \
  findutils \
  groff-base \
  glibc-locale-source \
  glibc-langpack-en \
  gettext \
  rsync \
  scl-utils \
  tar \
  unzip \
  xz \
  yum" && \
  mkdir -p ${HOME}/.pki/nssdb && \
  chown -R 1001:0 ${HOME}/.pki && \
  yum -y update && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum -y clean all --enablerepo='*' && \
  rm -rf /var/cache/dnf

# Copy extra files to the image.
COPY ./root/ /

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path.
WORKDIR ${HOME}

# Reset permissions of modified directories and add default user
RUN rpm-file-permissions && \
  useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default && \
  chown -R 1001:0 ${APP_ROOT}


############
# s2i base #
############
# From: https://github.com/red-hat-data-services/s2i-base-container

# This is the list of basic dependencies that all language container image can
# consume.
RUN INSTALL_PKGS="autoconf \
  automake \
  bzip2 \
  gcc-c++ \
  gd-devel \
  gdb \
  git \
  libcurl-devel \
  libpq-devel \
  libxml2-devel \
  libxslt-devel \
  lsof \
  make \
  mariadb-connector-c-devel \
  nodejs \
  openssl-devel \
  patch \
  procps-ng \
  npm \
  redhat-rpm-config \
  sqlite-devel \
  unzip \
  wget \
  which \
  zlib-devel" && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum -y clean all --enablerepo='*' && \
  rm -rf /var/cache/dnf

############
# s2i py39 #
############
# From: https://github.com/red-hat-data-services/s2i-python-container

EXPOSE 8080

ENV PYTHON_VERSION=3.9 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    CNB_STACK_ID=com.redhat.stacks.ubi8-python-39 \
    CNB_USER_ID=1001 \
    CNB_GROUP_ID=0 \
    PIP_NO_CACHE_DIR=off

# RHEL7 base images automatically set these envvars to run scl_enable. RHEl8
# images, however, don't as most images don't need SCLs any more. But we want
# to run it even on RHEL8, because we set the virtualenv environment as part of
# that script
ENV BASH_ENV=${APP_ROOT}/etc/scl_enable \
    ENV=${APP_ROOT}/etc/scl_enable \
    PROMPT_COMMAND=". ${APP_ROOT}/etc/scl_enable"

RUN INSTALL_PKGS="python3 python3-devel python3-setuptools python3-pip nss_wrapper \
        httpd httpd-devel mod_ssl mod_auth_gssapi mod_ldap \
        mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    rm -rf /var/cache/dnf

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY 3.9/s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY 3.9/root/ /

# - Create a Python virtual environment for use by any application to avoid
#   potential conflicts with Python packages preinstalled in the main Python
#   installation.
# - In order to drop the root user, we have to make some directories world
#   writable as OpenShift default security model is to run the container
#   under random UID.
RUN \
    python3.9 -m venv ${APP_ROOT} && \
    # Python 3 only code, Python 2 installs pip from PyPI in the assemble script. \
    # We have to upgrade pip to a newer verison because: \
    # * pip < 9 does not support different packages' versions for Python 2/3 \
    # * pip < 19.3 does not support manylinux2014 wheels. Only manylinux2014 (and later) wheels \
    #   support platforms like ppc64le, aarch64 or armv7 \
    # We are newly using wheel from one of the latest stable Fedora releases (from RPM python-pip-wheel) \
    # because it's tested better then whatever version from PyPI and contains useful patches. \
    # We have to do it here (in the macro) so the permissions are correctly fixed and pip is able \
    # to reinstall itself in the next build phases in the assemble script if user wants the latest version \
    ${APP_ROOT}/bin/pip install /opt/wheels/pip-* && \
    rm -r /opt/wheels && \
    chown -R 1001:0 ${APP_ROOT} && \
    fix-permissions ${APP_ROOT} -P && \
    rpm-file-permissions

#################
# Other configs #
#################

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

CMD /opt/app-root/bin/start-singleuser.sh
