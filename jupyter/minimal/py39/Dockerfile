ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

LABEL name="workbench-images:${CUDA}jupyter-minimal-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Minimal JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Minimal JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Minimal JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Minimal JupyterLab notebook with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/opendatahub-io-contrib/workbench-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/opendatahub-io-contrib/workbench-images/jupyter/minimal" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/workbench-images:${CUDA}jupyter-minimal-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

####################
# Minimal notebook #
####################

WORKDIR /opt/app-root/bin

COPY utils utils/
COPY Pipfile.lock start-notebook.sh ./

# Install packages and cleanup
# (all commands are chained to minimize layer size)
RUN echo "Installing softwares and packages" && \
    # Install Python packages \
    micropipenv install && \
    rm -f ./Pipfile.lock && \
    # Fix Kernel name with the exact Python version \
    sed -i -e "s/Python.*/$(python --version)\",/" /opt/app-root/share/jupyter/kernels/python3/kernel.json && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src

ENTRYPOINT ["start-notebook.sh"]
