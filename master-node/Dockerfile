FROM sporule/big-data-cluster:hadoop-base


LABEL  credit="https://github.com/big-data-europe/docker-hadoop"
LABEL  maintainer = "Sporule <hao@sporule.com>"

# Set up environment variables

ARG hive_version=3.1.2
ENV HIVE_VERSION=$hive_version
ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH


# Making sure services are not running
HEALTHCHECK CMD curl -f http://localhost:9870/ && curl -f http://localhost:8088/  && curl -f http://localhost:8188/ || exit 1

# Set up Name Node
ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

# Set up Yarn
ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline
RUN mkdir -p /hadoop/yarn/timeline
VOLUME /hadoop/yarn/timeline

# Set up Hive
WORKDIR /opt
RUN apt-get update && apt-get install -y wget procps && \
	wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin hive && \
	wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
	rm apache-hive-$HIVE_VERSION-bin.tar.gz \
	&& rm /opt/hive/lib/guava-19.0.jar \
	&& cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar /opt/hive/lib

ADD hive-conf/hive-site.xml $HIVE_HOME/conf
ADD hive-conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/hive-env.sh $HIVE_HOME/conf
ADD hive-conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/hive-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/ivysettings.xml $HIVE_HOME/conf
ADD hive-conf/llap-daemon-log4j2.properties $HIVE_HOME/conf


# Install Python3 Build Environment

WORKDIR /
RUN apt-get install -y python-dev python3-dev \
	build-essential libssl-dev libffi-dev \
	libxml2-dev libxslt1-dev zlib1g-dev \
	python-pip python3-pip

# Set up Airflow
RUN export AIRFLOW_HOME=/root/airflow \
	&& pip install apache-airflow \
	&& mkdir -p /landing_zone


# Set up Spark
ARG spark_version=3.0.1
ENV SPARK_VERSION=$spark_version

RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.2.tgz \
	&& tar -xvzf spark-$SPARK_VERSION-bin-hadoop3.2.tgz \
	&& mv spark-$SPARK_VERSION-bin-hadoop3.2 spark \
	&& rm spark-$SPARK_VERSION-bin-hadoop3.2.tgz \
	&& wget https://jdbc.postgresql.org/download/postgresql-42.2.17.jar -P /spark/jars/ \
	&& wget https://search.maven.org/remotecontent?filepath=org/mongodb/spark/mongo-spark-connector_2.12/3.0.0/mongo-spark-connector_2.12-3.0.0.jar -O /spark/jars/mongo-spark-connector_2.12-3.0.0.jar


ENV PYTHONHASHSEED 1

# Set up environment variable
ENV SPARK_HOME /spark
COPY spark-env.sh /spark/conf/
COPY spark-defaults.conf /spark/conf/
COPY statsd-jvm-profiler-2.1.0.jar /statsd-jvm-profiler.jar
ENV PATH $SPARK_HOME/bin:$PATH

# Set up ZooKeeper

ARG zookeeper_version=3.4.6
ENV ZOOKEEPER_VERSION=$zookeeper_version

RUN wget https://archive.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz \
	&& tar -xvzf zookeeper-$ZOOKEEPER_VERSION.tar.gz \
  && mv zookeeper-$ZOOKEEPER_VERSION /zookeeper \
  && rm zookeeper-$ZOOKEEPER_VERSION.tar.gz \
  && mkdir /root/zookeeper

COPY zookeeper-conf/zoo.cfg /zookeeper/conf 

# Set up Kafka

ARG kafka_version=2.0.0
ENV KAFKA_VERSION=$kafka_version

RUN wget https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_2.12-$KAFKA_VERSION.tgz \
	&& tar -xvzf kafka_2.12-$KAFKA_VERSION.tgz \
	&& mv kafka_2.12-$KAFKA_VERSION /kafka \
	&& rm kafka_2.12-$KAFKA_VERSION.tgz


# Clean Packages
RUN	apt-get --purge remove -y wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 8188
EXPOSE 9000
EXPOSE 9870
EXPOSE 8080
EXPOSE 8088
EXPOSE 10000
EXPOSE 10002
EXPOSE 2181
EXPOSE 9092


# Setup Config and starting services
ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
