FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2

USER root

# Install R
RUN yum -y update && \
    yum install -y libXext libXt-devel libXrender cairo-devel cairo \
    openssl-devel libcurl-devel libssh2-devel libxml2-devel czmq-devel \
    R-Cairo R-core R-core-devel R-java R-Rcpp R-highlight R-littler \
    R-littler-examples && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

# Install R Kernel
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/lib64/R/etc/Rprofile.site && \
    R -e "install.packages('IRkernel')" && \
    R -e "IRkernel::installspec(user = FALSE, name = 'ir405', displayname = 'R 4.0.5', sys_prefix = TRUE)" && \
    sed -i 's/"IRkernel::main()"/"options(bitmapType=\x27cairo\x27);IRkernel::main()"/g' /opt/app-root/share/jupyter/kernels/ir405/kernel.json

# set library to default (used in install.r from littler)
ENV LIBLOC /usr/lib64/R/library

# Copying custom packages
COPY requirements.txt /tmp/

WORKDIR /tmp/

# Install custom packages
RUN micropipenv install --deploy 
RUN pip install --no-cache-dir --use-deprecated legacy-resolver elyra[all]==3.6.0 && \
    jupyter labextension install @techrah/text-shortcuts && \
    jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf $HOME/.cache/yarn && \
    rm -rf $HOME/.node-gyp && \
    fix-permissions /opt/app-root

WORKDIR /opt/app-root/src
USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 --port=8080
