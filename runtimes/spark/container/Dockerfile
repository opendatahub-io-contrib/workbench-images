ARG BASE_IMAGE
FROM ${BASE_IMAGE} as builder

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG RELEASE
ARG DATE
ARG CUDA

# Build options
ARG SPARK_VERSION=3.3.1
ARG HADOOP_VERSION=3.3.4
ARG JMX_PROMETHEUS_JAVAAGENT_VERSION=0.17.0
# Spark's Guava version to match with Hadoop's
ARG GUAVA_VERSION=27.0-jre

LABEL name="runtime-images:${CUDA}spark-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/guimou/runtime-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/guimou/runtime-images/jupyter/spark" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/runtime-images:${CUDA}spark-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

USER 0

WORKDIR /

# Install gzip to extract archives
RUN dnf install -y gzip && \
    dnf clean all

# Download Spark
ADD https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz .
# Unzip Spark
RUN tar -xvzf spark-${SPARK_VERSION}-bin-without-hadoop.tgz --no-same-owner
RUN mv spark-${SPARK_VERSION}-bin-without-hadoop spark

# Download Hadoop
ADD https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz .
# Unzip Hadoop
RUN tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz --no-same-owner
RUN mv hadoop-${HADOOP_VERSION} hadoop
# Delete unnecessary hadoop documentation
RUN rm -rf hadoop/share/doc

# Download JMX Prometheus javaagent jar
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_PROMETHEUS_JAVAAGENT_VERSION}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_JAVAAGENT_VERSION}.jar /prometheus/
RUN chmod 0644 prometheus/jmx_prometheus_javaagent*.jar

# Add updated Guava
WORKDIR /spark/jars
RUN rm -f guava-*.jar
ADD https://repo1.maven.org/maven2/com/google/guava/guava/${GUAVA_VERSION}/guava-${GUAVA_VERSION}.jar .

# Add Spark Hadoop Cloud to interact with cloud infrastructures
ADD https://repo1.maven.org/maven2/org/apache/spark/spark-hadoop-cloud_2.12/${SPARK_VERSION}/spark-hadoop-cloud_2.12-${SPARK_VERSION}.jar .

### Build final image
FROM ${BASE_IMAGE}

ARG UBI_VERSION
ARG PYTHON_VERSION
ARG PYTHON_VERSION_LONG
ARG JAVA_VERSION=1.8.0
ARG PKG_ROOT=/opt/app-root
ARG SPARK_VERSION=3.3.1
ARG HADOOP_VERSION=3.3.4
ARG JMX_PROMETHEUS_JAVAAGENT_VERSION=0.17.0

LABEL name="runtime-images:${CUDA}spark-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}" \
    summary="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    description="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    io.k8s.description="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION} for ODH or RHODS" \
    io.k8s.display-name="Datascience + Spark runtime with ${PYTHON_VERSION_LONG} based on ${UBI_VERSION}" \
    authoritative-source-url="https://github.com/guimou/runtime-images" \
    io.openshift.build.commit.ref="${RELEASE}" \
    io.openshift.build.source-location="https://github.com/guimou/runtime-images/jupyter/spark" \
    io.openshift.build.image="https://quay.io/opendatahub-contrib/runtime-images:${CUDA}spark-${UBI_VERSION}-${PYTHON_VERSION}_${RELEASE}_${DATE}"

USER 0

WORKDIR ${PKG_ROOT}/${SPARK_VERSION}

####################
# OpenJDK          #
####################

RUN yum -y install java-$JAVA_VERSION-openjdk maven &&\
    yum clean all

####################
# Spark            #
####################

# Copy Spark from builder stage
COPY --from=builder --chown=default:root /spark ${PKG_ROOT}/spark-${SPARK_VERSION}
COPY --from=builder --chown=default:root /spark/kubernetes/dockerfiles/spark/entrypoint.sh /opt/app-root/bin

# Copy Hadoop from builder stage
COPY --from=builder --chown=default:root /hadoop ${PKG_ROOT}/hadoop-${HADOOP_VERSION}

# Copy Prometheus jars from builder stage
COPY --from=builder --chown=default:root /prometheus ${PKG_ROOT}/prometheus

# Setup required env vars for spark and hadoop
ENV JAVA_HOME=/usr/lib/jvm/jre
ENV SPARK_HOME=${PKG_ROOT}/spark-${SPARK_VERSION}
ENV HADOOP_HOME ${PKG_ROOT}/hadoop-${HADOOP_VERSION}

ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:/contrib/capacity-scheduler/*.jar:$HADOOP_HOME/share/hadoop/tools/lib/*"

ENV SPARK_EXTRA_CLASSPATH="$SPARK_DIST_CLASSPATH"

ENV LD_LIBRARY_PATH /lib64

ENV PATH="${PATH}:${PKG_ROOT}/spark-${SPARK_VERSION}/bin"

WORKDIR /opt/app-root/src

USER 1001

# Install PySpark and cleanup
RUN pip install --no-cache-dir pyspark~=3.3.1 && \
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P
