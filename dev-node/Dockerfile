FROM sporule/big-data-cluster:hadoop-base-3.1.1


LABEL  modification-from="https://github.com/big-data-europe/docker-hadoop"
LABEL  maintainer = "Sporule <hao@sporule.com>"


ARG hive_version=3.1.0
ENV HIVE_VERSION=$hive_version
ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH

WORKDIR /opt
RUN apt-get update && apt-get install -y ssh wget procps vim&& \
	wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin hive && \
	wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
	rm apache-hive-$HIVE_VERSION-bin.tar.gz

ADD hive-conf/hive-site.xml $HIVE_HOME/conf
ADD hive-conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/hive-env.sh $HIVE_HOME/conf
ADD hive-conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/hive-log4j2.properties $HIVE_HOME/conf
ADD hive-conf/ivysettings.xml $HIVE_HOME/conf
ADD hive-conf/llap-daemon-log4j2.properties $HIVE_HOME/conf

WORKDIR /

ARG spark_version=2.3.2
ENV SPARK_VERSION=$spark_version

RUN apt-get update && apt-get install -y wget  \
	&& wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz \
	&& apt-get --purge remove -y wget \
	&& tar -xvzf spark-$SPARK_VERSION-bin-without-hadoop.tgz \
	&& mv spark-$SPARK_VERSION-bin-without-hadoop spark \
	&& rm spark-$SPARK_VERSION-bin-without-hadoop.tgz \
	&& cd / \
	&& 	apt-get --purge remove -y wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ENV SPARK_HOME /spark/
ADD hive-conf/hive-site.xml /spark/conf/
COPY spark-env.sh /spark/conf/
COPY statsd-jvm-profiler-2.1.0.jar /statsd-jvm-profiler.jar

ENV PYTHONHASHSEED 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

# Add SSH
COPY .ssh/ /root/.ssh/
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

EXPOSE 22

WORKDIR /workspace

CMD ["/run.sh"]