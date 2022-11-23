ARG BASE_IMAGE
FROM ${BASE_IMAGE} as builder

# Build options
ARG SPARK_VERSION=3.3.1
ARG HADOOP_VERSION=3.3.4
ARG JMX_PROMETHEUS_JAVAAGENT_VERSION=0.17.0
# Spark's Guava version to match with Hadoop's
ARG GUAVA_VERSION=27.0-jre

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

LABEL name="s2i-aprk-${UBI_VERSION}-${PYTHON_VERSION}:latest" \
    summary="S2I Spark with ${PYTHON_VERSION_LONG} image based on ${UBI_VERSION}" \
    description="Spark notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.description="Spark notebook with ${PYTHON_VERSION_LONG}, Source-to-Image from ${UBI_VERSION}" \
    io.k8s.display-name="S2I Spark notebook with ${PYTHON_VERSION_LONG} ${UBI_VERSION} image" \
    authoritative-source-url="https://github.com/guimou/custom-notebooks" \
    io.openshift.s2i.build.commit.ref="main" \
    io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks/notebook-controller-images/s2i-spark" \
    io.openshift.s2i.build.image="https://quay.io/guimou/s2i-spark-${UBI_VERSION}-${PYTHON_VERSION}"

USER 0

WORKDIR ${PKG_ROOT}/${SPARK_VERSION}

####################
# OpenJDK          #
####################

# Fix for https://issues.redhat.com/browse/OPENJDK-335
ENV NSS_WRAPPER_PASSWD=
ENV NSS_WRAPPER_GROUP=

RUN yum -y install java-$JAVA_VERSION-openjdk maven &&\
    yum clean all

####################
# Spark            #
####################

# Copy Spark from builder stage
COPY --from=builder /spark ${PKG_ROOT}/spark-${SPARK_VERSION}

# Copy Hadoop from builder stage
COPY --from=builder /hadoop ${PKG_ROOT}/hadoop-${HADOOP_VERSION}

# Copy Prometheus jars from builder stage
COPY --from=builder /prometheus ${PKG_ROOT}/prometheus

RUN chown -R 1001:0 ${PKG_ROOT}

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

RUN pip install pyspark==3.3.1

RUN fix-permissions ${PKG_ROOT}

CMD /opt/app-root/bin/start-singleuser.sh
