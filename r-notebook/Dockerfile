FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2

USER root

# Setup EPEL
#RUN yum -y --disableplugin=subscription-manager install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
#    yum -y --nobest --skip-broken --disableplugin=subscription-manager update 

# Install R
RUN yum -y install \
    R-core R-core-devel R-java R-Rcpp R-highlight R-littler \
    R-littler-examples \
  && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/lib64/R/etc/Rprofile.site

# set library to default (used in install.r from littler)
ENV LIBLOC /usr/lib64/R/library

USER 1001

RUN echo -e 'R_LIBS=/users/home/${JUPYTERHUB_USER}/R' > /opt/app-root/src/.Renviron

CMD [ "/opt/app-root/builder/run" ]