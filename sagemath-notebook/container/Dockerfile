FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2

USER root

# Install SageMath
RUN yum -y update && \
    yum -y install sagemath && \
    yum -y clean all && \
    rm -rf /var/cache/dnf

WORKDIR /tmp/

# Copy requirements and Dockerfile
COPY requirements.txt Dockerfile /tmp/

# Replace launch script to define module command needed by SageMath
COPY start-singleuser.sh /opt/app-root/bin/start-singleuser.sh

    # Fix Python location in sage because of our venv
RUN sed -i 's/exec python3/exec \/usr\/bin\/python3/g' /usr/lib64/sagemath/local/bin/sage && \
    # Fix for Sage doc (not installed to minimize size)
    ln -s -f /usr/share/doc/sagemath /usr/share/jupyter/kernels/sagemath/doc && \
    # Fix for Threejs location
    ln -s /usr/share/sagemath/threejs/threejs-sage-r122/version /usr/share/sagemath/threejs/version && \
    # Install Kernel
    ln -s /usr/lib64/sagemath/local/share/jupyter/kernels/sagemath /opt/app-root/share/jupyter/kernels/sagemath && \
    # Hide Gap Kernel
    rm -rf /usr/share/jupyter/kernels/gap-4 && \
    # Install requirements
    micropipenv install --deploy && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf /usr/local/share/.cache/yarn && \
    fix-permissions /opt/app-root

# Fix Python Kernel name
RUN sed -i 's/"Python 3 (ipykernel)"/"Python 3.9.10"/g' /opt/app-root/share/jupyter/kernels/python3/kernel.json

WORKDIR /opt/app-root/src
USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 --port=8080
