FROM sporule/big-data-cluster:hadoop-base


LABEL  credit="https://github.com/big-data-europe/docker-hadoop"
LABEL  maintainer = "Sporule <hao@sporule.com>"


# Making sure services are not running
HEALTHCHECK CMD curl -f http://localhost:9864/ && curl -f http://localhost:8042/  || exit 1

# Set up Data Node
ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

# Expose Port
EXPOSE 9864
EXPOSE 8042

# Set Configuration and Start Data Node and Node Manager
ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
