ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG

LABEL name="s2i-datascience-notebook-${UBI_VERSION}-${PYTHON_VERSION}:latest" \
    summary="S2I datascience notebook ${PYTHON_VERSION_LONG} image based on ${UBI_VERSION}" \
    description="Datascience notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.description="Datascience notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.display-name="S2I Datascience notebook ${PYTHON_VERSION_LONG} ${UBI_VERSION} image" \
    authoritative-source-url="https://github.com/guimou/custom-notebooks" \
    io.openshift.s2i.build.commit.ref="main" \
    io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks/notebook-controller-images/s2i-datascience-notebook" \
    io.openshift.s2i.build.image="https://quay.io/guimou/s2i-datascience-notebook-${UBI_VERSION}-${PYTHON_VERSION}"

########################
# Datascience notebook #
########################

USER 0

WORKDIR /tmp/

# Copying custom packages
COPY Pipfile Pipfile.lock /tmp/
RUN micropipenv install --deploy && \
    rm -rf /opt/app-root/lib/python3.8/site-packages/~*

# Streamlit extenstion installation
COPY streamlit-launcher.sh /opt/app-root/bin/
COPY streamlit-menu/dist/jupyterlab_streamlit_menu-0.1.0-py3-none-any.whl /tmp/

# Install packages and cleanup upgrades
RUN pip install --no-cache-dir /tmp/jupyterlab_streamlit_menu-0.1.0-py3-none-any.whl

RUN jupyter lab build && \
    jupyter lab clean && \
    npm install -g yarn && \
    npm cache clean --force && \
    yarn cache clean && \
    fix-permissions /opt/app-root

WORKDIR /opt/app-root/src
USER 1001

CMD /opt/app-root/bin/start-singleuser.sh
