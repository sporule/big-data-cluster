FROM debian:10


LABEL  credit="https://github.com/big-data-europe/docker-hadoop"
LABEL  maintainer = "Sporule <hao@sporule.com>"

# Define Hadoop Version, this is for download path
ARG hadoop_version=3.3.0

# Set Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
ENV HADOOP_VERSION=$hadoop_version
ENV HADOOP_URL https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH

# Install build dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common\
    net-tools \
    curl wget\
    netcat \
    gnupg \
    python3 python3-distutils python3-apt \
    openjdk-11-jdk

# Clean Package Management Archive
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Install Pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py --force-reinstall

# Import Hadoop Keys
RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS
RUN gpg --import KEYS

# Install Hadoop
RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*
RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs
RUN mkdir /hadoop-data

# Export entrypoint for configurations
ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]