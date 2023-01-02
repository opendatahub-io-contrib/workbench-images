FROM quay.io/sclorg/s2i-base-c9s:c9s

ARG RELEASE
ARG DATE

LABEL name="workbench-images:base-c9s-py39_${RELEASE}_${DATE}" \
    summary="Centos Stream 9-Python 3.9 base for workbench images" \
    description="Centos Stream 9-Python 3.9 base for workbench images" \
    io.k8s.description="Centos Stream 9-Python 3.9 base for workbench images" \
    io.k8s.display-name="Centos Stream 9-Python 3.9 base for workbench images for ODH or RHODS" \
    authoritative-source-url="https://github.com/opendatahub-io-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-io-contrib/workbench-images/jupyter/base/c9s" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:base-c9s-py39_${RELEASE}_${DATE}"

# This will avoid people forgetting to set no-cache-dir when building images
ENV PIP_NO_CACHE_DIR=1

USER 0

# Update base image for latest security updates
# (ubi images are not released that often)
RUN dnf -y  --setopt=tsflags=nodocs update && \
    dnf -y clean all --enablerepo='*'

############
# s2i py39 #
############
# From: https://github.com/sclorg/s2i-python-container

EXPOSE 8080

ENV PYTHON_VERSION=3.9 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

ENV NAME=python3 \
    VERSION=0 \
    ARCH=x86_64

RUN INSTALL_PKGS="python3 python3-devel python3-setuptools python3-pip nss_wrapper \
        httpd httpd-devel mod_ssl mod_auth_gssapi mod_ldap \
        mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl \
        enchant krb5-devel" && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf -y clean all --enablerepo='*'

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
RUN python3.9 -m venv ${APP_ROOT} && \
    # Python 3.7+ only code, Python <3.7 installs pip from PyPI in the assemble script. \
    # We have to upgrade pip to a newer version because: \
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
    fix-permissions ${APP_ROOT} -P

# For Fedora scl_enable isn't sourced automatically in core
# so virtualenv needs to be activated this way
ENV BASH_ENV="${APP_ROOT}/bin/activate" \
    ENV="${APP_ROOT}/bin/activate" \
    PROMPT_COMMAND=". ${APP_ROOT}/bin/activate"

#####################
# Base image config #
#####################

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
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src
