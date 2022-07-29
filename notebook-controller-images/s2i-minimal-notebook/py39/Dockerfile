ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG

LABEL name="s2i-minimal-notebook-${UBI_VERSION}-${PYTHON_VERSION}:latest" \
    summary="S2I minimal notebook ${PYTHON_VERSION_LONG} image based on ${UBI_VERSION}" \
    description="Minimal notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.description="Minimal notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.display-name="S2I Minimal notebook ${PYTHON_VERSION_LONG} ${UBI_VERSION} image" \
    authoritative-source-url="https://github.com/guimou/custom-notebooks" \
    io.openshift.s2i.build.commit.ref="main" \
    io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks/notebook-controller-images/s2i-minimal-notebook" \
    io.openshift.s2i.build.image="https://quay.io/guimou/s2i-minimal-notebook-${UBI_VERSION}-${PYTHON_VERSION}"

####################
# Minimal notebook #
####################

USER 0

ENV JUPYTER_ENABLE_LAB="true" \
    ENABLE_MICROPIPENV="1" \
    UPGRADE_PIP_TO_LATEST="1" \
    WEB_CONCURRENCY="1"

# Copying in override assemble/run scripts
COPY minimal/.s2i/bin /tmp/scripts
# Copying in source code
COPY minimal/. /tmp/src
# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/scripts /tmp/src

WORKDIR /opt/app-root/src
USER 1001
RUN /tmp/scripts/assemble && \
    # Fix Kernel name with the exact Python version
    sed -i -e "s/Python.*/$(python --version)\",/" /opt/app-root/share/jupyter/kernels/python3/kernel.json

CMD /opt/app-root/bin/start-singleuser.sh
