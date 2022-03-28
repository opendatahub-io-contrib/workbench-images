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
RUN sed -i 's/exec python3/exec \/usr\/bin\/python3/g' /usr/lib64/sagemath/local/bin/sage

# Fix for Sage doc (not installed to minimize size)
RUN ln -s -f /usr/share/doc/sagemath /usr/share/jupyter/kernels/sagemath/doc

# Install Kernel
RUN ln -s /usr/lib64/sagemath/local/share/jupyter/kernels/sagemath /opt/app-root/share/jupyter/kernels/sagemath

# Install requirements
RUN micropipenv install --deploy && \
    fix-permissions /opt/app-root

WORKDIR /opt/app-root/src
USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 --port=8080
