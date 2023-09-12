#!/bin/bash
set -x

# Set the elyra config on the right path
jupyter elyra --generate-config
cp /opt/app-root/bin/utils/jupyter_elyra_config.py /opt/app-root/src/.jupyter/

# create the elyra runtime directory if not present
if [ ! -d $(jupyter --data-dir)/metadata/runtimes/ ]; then
  mkdir -p $(jupyter --data-dir)/metadata/runtimes/
fi
# Set elyra runtime config from volume mount
if [ "$(ls -A /opt/app-root/runtimes/)" ]; then
  cp -r /opt/app-root/runtimes/..data/*.json $(jupyter --data-dir)/metadata/runtimes/
fi

# Environment vars set for accessing ssl_sa_certs and sa_token
# export PIPELINES_SSL_SA_CERTS="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
export KF_PIPELINES_SA_TOKEN_ENV="/var/run/secrets/kubernetes.io/serviceaccount/token"
export KF_PIPELINES_SA_TOKEN_PATH="/var/run/secrets/kubernetes.io/serviceaccount/token"
# Environment vars set for accessing following dependencies for air-gapped enviroment
export ELYRA_BOOTSTRAP_SCRIPT_URL="file:///opt/app-root/bin/utils/bootstrapper.py"
export ELYRA_PIP_CONFIG_URL="file:///opt/app-root/bin/utils/pip.conf"
export ELYRA_REQUIREMENTS_URL="file:///opt/app-root/bin/utils/requirements-elyra.txt"