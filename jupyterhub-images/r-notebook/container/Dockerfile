FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2

USER root

# Install R
RUN yum -y update && \
    yum -y install R-Cairo R-core R-core-devel R-java R-Rcpp R-highlight \
    R-littler R-littler-examples && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

# Install R Kernel
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/lib64/R/etc/Rprofile.site && \
    R -e "install.packages('IRkernel')" && \
    R -e "IRkernel::installspec(user = FALSE, name = 'ir405', displayname = 'R 4.0.5', sys_prefix = TRUE)" && \
    sed -i 's/"IRkernel::main()"/"options(bitmapType=\x27cairo\x27);IRkernel::main()"/g' /opt/app-root/share/jupyter/kernels/ir405/kernel.json

# set R library to default (used in install.r from littler)
ENV LIBLOC /usr/lib64/R/library

# create User R Library path at startup if not present
RUN sed -i '1s/^/mkdir -p  \/opt\/app-root\/src\/Rpackages\/4.0 \n/' /opt/app-root/bin/start-singleuser.sh
# set User R Library path
ENV R_LIBS_USER /opt/app-root/src/Rpackages/4.0

WORKDIR /tmp/

# Install RStudio
RUN wget https://download2.rstudio.org/server/rhel8/x86_64/rstudio-server-rhel-2022.02.0-443-x86_64.rpm && \
    yum -y install rstudio-server-rhel-2022.02.0-443-x86_64.rpm && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

# Specific RStudio config and fixes
RUN chmod 1777 /var/run/rstudio-server && \
    mkdir -p /usr/share/doc/R
COPY rsession.conf /etc/rstudio/rsession.conf

# Copying additional packages
COPY requirements.txt /tmp/
COPY ./jupyter-rsession-proxy /tmp/jupyter-rsession-proxy

# Install additional packages
RUN micropipenv install --deploy && \
    pip install --no-cache-dir /tmp/jupyter-rsession-proxy && \
    jupyter labextension install @techrah/text-shortcuts && \
    jupyter labextension install @jupyterlab/server-proxy && \
    jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf /usr/local/share/.cache/yarn && \
    fix-permissions /opt/app-root

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 --port=8080
