FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2

USER root

# Install JDK
RUN yum -y update && \
    yum -y install java-11-openjdk java-11-openjdk-devel && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

WORKDIR /tmp/

# Copying custom packages
COPY requirements.txt /tmp/

# Install custom packages
RUN micropipenv install --deploy 

WORKDIR /opt/app-root/src
USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0
