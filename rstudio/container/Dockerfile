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

ENV R_VERSION=4.2.2

# Install R
RUN yum install -y yum-utils && \
    yum-config-manager --enable crb && \
    yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    INSTALL_PKGS="R-core R-core-devel R-java R-Rcpp R-highlight \
    R-littler R-littler-examples openssl-libs compat-openssl11" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/lib64/R/etc/Rprofile.site && \
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
    yum -y clean all  --enablerepo='*' && \
    rm -rf /var/cache/dnf

# Specific RStudio config and fixes
RUN chmod 1777 /var/run/rstudio-server && \
    mkdir -p /usr/share/doc/R
COPY rsession.conf /etc/rstudio/rsession.conf

# Launcher
WORKDIR /opt/app-root/bin

COPY utils utils/
COPY run-rstudio.sh setup_rstudio.py rsession.sh ./

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/run-rstudio.sh
