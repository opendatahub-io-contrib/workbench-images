FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.3.0

LABEL name="s2i-generic-data-science-streamlit-notebook:latest" \
      summary="Generic Data Science Jupyter Notebook Source-to-Image for Python 3.9 applications." \
      description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.display-name="Generic Data Science with Streamlit Notebook Python 3.9-ubi8 S2I" \
      io.openshift.expose-services="8888:http" \
      io.openshift.tags="python,python39" \
      authoritative-source-url="https://quay.io/guimou/s2i-generic-data-science-streamlit-notebook" \
      io.openshift.s2i.build.commit.ref="main" \
      io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks" \
      io.openshift.s2i.build.image="quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2"

USER root

WORKDIR /tmp/

# Copying custom packages
COPY Pipfile Pipfile.lock /tmp/
RUN micropipenv install --deploy && \
    rm -rf /opt/app-root/lib/python3.9/site-packages/~*

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

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0
