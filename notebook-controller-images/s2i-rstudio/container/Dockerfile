ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG COS_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG

LABEL name="s2i-rstudio-${COS_VERSION}-${PYTHON_VERSION}:latest" \
    summary="S2I RStudio with ${PYTHON_VERSION_LONG} image based on ${COS_VERSION}" \
    description="RStudio notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${COS_VERSION}" \
    io.k8s.description="RStudio notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${COS_VERSION}" \
    io.k8s.display-name="S2I RStudio notebook with ${PYTHON_VERSION_LONG} ${COS_VERSION} image" \
    authoritative-source-url="https://github.com/guimou/custom-notebooks" \
    io.openshift.s2i.build.commit.ref="main" \
    io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks/notebook-controller-images/s2i-rstudio" \
    io.openshift.s2i.build.image="https://quay.io/guimou/s2i-rstudio-${COS_VERSION}-${PYTHON_VERSION}"

####################
# RStudio          #
####################

USER 0

# Install R
RUN yum install -y yum-utils && \
    yum-config-manager --enable crb && \
    yum install -y https://download.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    INSTALL_PKGS="R-core R-core-devel R-java R-Rcpp R-highlight \
    R-littler R-littler-examples openssl-libs compat-openssl11" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/lib64/R/etc/Rprofile.site && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

# set some defaults
ENV LIBLOC /usr/lib64/R/library

# set User R Library path
ENV R_LIBS_USER /opt/app-root/src/Rpackages/4.1

WORKDIR /tmp/

# Install RStudio
RUN wget https://download2.rstudio.org/server/rhel8/x86_64/rstudio-server-rhel-2022.07.1-554-x86_64.rpm && \
    yum install -y rstudio-server-rhel-2022.07.1-554-x86_64.rpm && \
    rm rstudio-server-rhel-2022.07.1-554-x86_64.rpm && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

# Specific RStudio config and fixes
RUN chmod 1777 /var/run/rstudio-server && \
    mkdir -p /usr/share/doc/R
COPY rsession.conf /etc/rstudio/rsession.conf

# Launcher
COPY run-rstudio.sh setup_rstudio.py rsession.sh /opt/app-root/bin/

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/run-rstudio.sh
