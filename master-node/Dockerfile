FROM sporule/big-data-cluster:hadoop-base-3.1.1


LABEL  credit="https://github.com/big-data-europe/docker-hadoop"
LABEL  maintainer = "Sporule <hao@sporule.com>"

# Set up environment variables

ARG hive_version=3.1.0
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
	rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
	apt-get --purge remove -y wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ADD hive-conf/hive-site.xml $HIVE_HOME/conf
ADD hive-conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/hive-env.sh $HIVE_HOME/conf
ADD hive-conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/hive-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/ivysettings.xml $HIVE_HOME/conf
ADD hive-conf/llap-daemon-log4j2.properties $HIVE_HOME/conf



# Install Python3 Build Environment

WORKDIR /
RUN apt-get install -y python3 python-dev python3-dev \
	build-essential libssl-dev libffi-dev \
	libxml2-dev libxslt1-dev zlib1g-dev \
	python-pip

# Set up Airflow
RUN export AIRFLOW_HOME=/root/airflow; pip install apache-airflow ; fi

# Expose ports
EXPOSE 8188
EXPOSE 9000
EXPOSE 9870
EXPOSE 8080
EXPOSE 8088
EXPOSE 10000
EXPOSE 10002


# Setup Config and starting services
ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
