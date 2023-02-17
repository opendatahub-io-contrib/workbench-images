ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="runtime-images:${CUDA}r-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="R runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="R runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="R runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="R runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/guimou/runtime-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/guimou/runtime-images/r" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/runtime-images:${CUDA}r-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

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

# Launcher
WORKDIR /opt/app-root/bin

WORKDIR /opt/app-root/src

USER 1001
