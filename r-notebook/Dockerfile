FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2

USER root

# Install R
RUN yum -y update && \
    yum -y install R-core R-core-devel R-java R-Rcpp R-highlight R-littler \
        R-littler-examples R-IRkernel && \
    yum -y clean all && \
    rm -rf /var/cache/dnf && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/lib64/R/etc/Rprofile.site

# set library to default (used in install.r from littler)
ENV LIBLOC /usr/lib64/R/library

# Copying custom packages
COPY requirements.txt /tmp/

# Install custom packages
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    pip install --no-cache-dir --use-deprecated legacy-resolver elyra[all]==3.6.0 && \
    jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf $HOME/.cache/yarn && \
    rm -rf $HOME/.node-gyp && \
    fix-permissions /opt/app-root

WORKDIR /opt/app-root/src
USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 --port=8080
