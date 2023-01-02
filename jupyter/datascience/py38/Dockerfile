ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="workbench-images:${CUDA}jupyter-datascience-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Datascience JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Datascience JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Datascience JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Datascience JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/opendatahub-io-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-io-contrib/workbench-images/jupyter/datascience" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:${CUDA}jupyter-datascience-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

########################
# Datascience notebook #
########################

WORKDIR /tmp

# Copying custom packages
COPY Pipfile.lock /.

# Streamlit extension installation
COPY streamlit-launcher.sh /opt/app-root/bin/
COPY streamlit-menu/dist/jupyterlab_streamlit_menu-0.1.0-py3-none-any.whl ./

# Copy Elyra setup to utils so that it's sourced at startup
COPY setup-elyra.sh ./utils/

# Install packages and cleanup
# (all commands are chained to minimize layer size)
RUN echo "Installing softwares and packages" && \
    # Install Python packages \
    micropipenv install && \
    rm -f ./Pipfile.lock && \
    pip install --no-cache-dir /tmp/jupyterlab_streamlit_menu-0.1.0-py3-none-any.whl && \
    rm -f jupyterlab_streamlit_menu-0.1.0-py3-none-any.whl && \
    # Remove Elyra logo from JupyterLab because this is not a pure Elyra image \
    sed -i 's/widget\.id === \x27jp-MainLogo\x27/widget\.id === \x27jp-MainLogo\x27 \&\& false/' /opt/app-root/share/jupyter/labextensions/@elyra/theme-extension/static/lib_index_js.*.js && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.8/site-packages && \
    fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src

ENTRYPOINT ["start-notebook.sh"]
