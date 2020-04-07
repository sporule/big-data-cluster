FROM 20cd44d4523e


LABEL  modification-from="https://github.com/big-data-europe/docker-hadoop"
LABEL  maintainer = "Sporule <hao@sporule.com>"

HEALTHCHECK CMD curl -f http://localhost:9864/ && curl -f http://localhost:8042/  || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9864
EXPOSE 8042

CMD ["/run.sh"]
