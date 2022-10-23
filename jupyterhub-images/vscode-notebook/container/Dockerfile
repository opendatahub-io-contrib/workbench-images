FROM quay.io/guimou/s2i-datascience-notebook-ubi9-py39:latest

ARG CODESERVER_VERSION=v4.7.1

####################
# CodeServer       #
####################

USER 0

WORKDIR /tmp

RUN yum install -y "https://github.com/coder/code-server/releases/download/${CODESERVER_VERSION}/code-server-${CODESERVER_VERSION/v/}-amd64.rpm" && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

COPY ./jupyter-vscode-proxy /tmp/jupyter-vscode-proxy

# Install launcher package
RUN pip install --no-cache-dir /tmp/jupyter-vscode-proxy && \
    fix-permissions /opt/app-root

ENV SHELL /usr/bin/sh

WORKDIR /opt/app-root/src

USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 
