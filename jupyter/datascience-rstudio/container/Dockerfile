ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="workbench-images:${CUDA}datascience-rstudio-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Data Science + R and RStudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Data Science + R and RStudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Data Science + R and RStudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Data Science + R and RStudio with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/opendatahub-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-contrib/workbench-images/jupyter/datascience-rstudio" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:${CUDA}datascience-rstudio-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"


####################
# R and RStudio    #
####################

USER 0

WORKDIR /opt/app-root/bin

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

# Install RStudio
RUN wget https://download2.rstudio.org/server/rhel8/x86_64/rstudio-server-rhel-2022.07.2-576-x86_64.rpm && \
    yum install -y rstudio-server-rhel-2022.07.2-576-x86_64.rpm && \
    rm rstudio-server-rhel-2022.07.2-576-x86_64.rpm && \
    yum -y clean all  --enablerepo='*' && \
    rm -rf /var/cache/dnf

# Specific RStudio config and fixes
RUN chmod 1777 /var/run/rstudio-server && \
    mkdir -p /usr/share/doc/R/html
COPY rsession.conf /etc/rstudio/rsession.conf

# Install R Kernel
RUN R -e "install.packages('IRkernel')" && \
    R -e "IRkernel::installspec(user = FALSE, name = 'ir42', displayname = 'R 4.2.2', sys_prefix = TRUE)" && \
    sed -i 's/"IRkernel::main()"/"options(bitmapType=\x27cairo\x27);IRkernel::main()"/g' /opt/app-root/share/jupyter/kernels/ir42/kernel.json && \
    chown -R 1001:0 /opt/app-root/src

USER 1001

# Copying additional packages
COPY --chown=default:root ./jupyter-rsession-proxy ./jupyter-rsession-proxy

# Install launcher package and cleanup
RUN pip install --no-cache-dir ./jupyter-rsession-proxy && \
    rm -rf ./jupyter-rsession-proxy && \
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src

ENTRYPOINT ["start-notebook.sh"] 
