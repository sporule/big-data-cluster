# Big Data Cluster

This is the Hadoop image based on the [BDE's Hadoop Base](https://github.com/big-data-europe/docker-hadoop) and its relevant forks.

This docker image is for development purpose, you should not use it for production without updating the configuration. I have modified some images and added some new features. 
You may find more information on [Sporule Blog](https://www.sporule.com) .

## Changes

### 22/04/2020

- Added Single Node Zookeeper to Master Node
- Added Airflow to Master Node

### 18/04/2020

- Updated Readme documentation

### 10/04/2020

- Added Dev Node with Airflow

### 02/04/2020

- Added Master Node and Worker Node with Hive

## Quick Start

### Run the whole cluster

```bash
docker-compose up -d
```

### Run Individual Contaier

You can run individual container by using Docker command, please find more information and tutorial on Docker website. Please remember to pass environment variables to the Docker command. You can find the relevant environment variables in the *docker-compose.yml* file.


## What is included


### Components

| Components       | Version | Included | Container         |
| ---------------- | ------- | -------- | ----------------- |
| Apache Accumulo  | 1.7.0   |          |                   |
| Apache Atlas     | 1.1.0   |          |                   |
| Apache Calcite   | 1.16.0  |          |                   |
| Apache DataFu    | 1.3.0   |          |                   |
| Apache Druid     | 0.12.1  |          |                   |
| Apache Hadoop    | 3.1.1   | Y        | Master,Worker,Dev |
| Apache HBase     | 2.0.2   |          |                   |
| Apache Hive      | 3.1.0   | Y        | Master,Worker,Dev |
| Apache Kafka     | 2.0.0   |          |                   |
| Apache Knox      | 1.0.0   |          |                   |
| Apache Livy      | 0.5.0   |          |                   |
| Apache Oozie     | 4.3.1   |          |                   |
| Apache Phoenix   | 5.0.0   |          |                   |
| Apache Pig       | 0.16.0  |          |                   |
| Apache Ranger    | 1.2.0   |          |                   |
| Apache Spark     | 2.3.2   | Y        | Master, Dev       |
| Apache Sqoop     | 1.4.7   |          |                   |
| Apache Storm     | 1.2.1   |          |                   |
| Apache TEZ       | 0.9.1   |          |                   |
| Apache Zeppelin  | 0.8.0   |          |                   |
| Apache ZooKeeper | 3.4.6   | Y        | Master            |
| Apache Airflow   | latest  | Y        | Master, Dev       |

### Containers in Docker-Compose

| Nodes          | Amount |
| -------------- | ------ |
| Master         | 1      |
| Worker         | 2      |
| Hive-metastore | 1      |
| Dev            | 1      |

> You can flexibly change the amount of worker nodes and dev nodes, they will connect with master node automatically

## Configurations

### Hadoop and Hive Basic Configuration 
The configuration parameters can be specified in the **hadoop.env** file or as environmental variables for specific services (e.g. master-node, worker-node etc.):
```
  CORE_CONF_fs_defaultFS=hdfs://master-node:8020
```

CORE_CONF corresponds to core-site.xml. fs_defaultFS=hdfs://master-node:8020 will be transformed into:
```
  <property><name>fs.defaultFS</name><value>hdfs://master-node:8020</value></property>
```
To define dash inside a configuration parameter, use triple underscore, such as YARN_CONF_yarn_log___aggregation___enable=true (yarn-site.xml):
```
  <property><name>yarn.log-aggregation-enable</name><value>true</value></property>
```

The available configurations are:
* /etc/hadoop/core-site.xml CORE_CONF
* /etc/hadoop/hdfs-site.xml HDFS_CONF
* /etc/hadoop/yarn-site.xml YARN_CONF
* /etc/hadoop/httpfs-site.xml HTTPFS_CONF
* /etc/hadoop/kms-site.xml KMS_CONF
* /etc/hadoop/mapred-site.xml  MAPRED_CONF
* /opt/hive/conf/hive-site.xml HIVE_SITE_CONF
  
### Application On or Off Configuration

You can turn on or off some applications by using environment variables, **0** means on and **1** means off. You can update the environment variable in the **hadoop.env** file or inject it while starting the containers (through Docker command or docker-compose.yml). However, it is good to note that **hadoop.env** will have lower priority. current supported applications are:

| Name      | Environment Variable | Default |
| --------- | -------------------- | ------- |
| Airflow   | AIRFLOW              | 0       |
| Zookeeper | ZOOKEEPER            | 0       |