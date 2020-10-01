# Big Data Cluster

This is the Hadoop image based on the [BDE's Hadoop Base](https://github.com/big-data-europe/docker-hadoop) and its relevant forks.

This docker image is for development purpose, you should not use it for production without updating the configuration. I have modified some images and added some new features. 
You may find more information on [Sporule Blog](https://www.sporule.com) .

## Changes

## 01/10/2020

- Replaced Jupyter Lab with Jupyter Hub, you can login by using the linux credential.

## 30/09/2020

- Updated the configuration file to tune the performance
- Added two environment variables relate to users in hadoop.env. You can use that to create users in dev-node with root and SSH login permission.
- Move Airflow to Master with landing-folder shared in dev nodes.
- Changed the default ports

## 12/08/2020

- Added Apache Livy with default port 8998 to dev-node
- Reduce the dev-node amount from 4 to 2

### 04/08/2020

- Upgraded Spark to 2.4.6 as the old version raised build error due to the repo issue
- Added NIFI in default port 8081
- Moved Airflow port to 8082

### 02/07/2020

- Changed Spark version to 2.4.5 as the old version raised build error due to the repo issue.
- Changed the hadoop environment setting and cluster setting to align with machine with 32GB RAM.
- Added Jupyter Lab with PySpark Support in dev nodes,you can now enable it by passing environment variable **JUPYTER=1**.  The default port 10110 is mapped to jupyter lab port 8080. The default token is sporule, you can change that in hadoop.env. Run findspark first before creating the spark context, examples below:

```bash
# In the docker-compose

  dev-node01:
    image: sporule/big-data-cluster:dev-node
    mem_limit: 480m
    container_name: dev-node01
    restart: always 
    ports:
      - "10022:22"
      - "10110:8080"
    volumes:
      - dev-node01_root:/root/
    environment:
        - AIRFLOW=0
        - JUPYTER=1
    env_file:
      - ./hadoop.env
    networks:
      - cluster

```

```python

# In the Jupyter Notebook

import findspark
findspark.init()

from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession

conf = SparkConf().setAppName('Ingestion')
spark = SparkSession.builder.config(conf=conf).getOrCreate() # Spark session will be created in the kernel after this line

```

### 24/04/2020

- Updated default port from 8088 to 10086 to avoid scanning attack

### 22/04/2020

- Added Single Node Zookeeper to Master Node
- Added Airflow to Master Node

### 18/04/2020

- Updated Readme documentation

### 10/04/2020

- Added Dev Node with Airflow

### 02/04/2020

- Added Master Node and Worker Node with Hive

## Quick Start Guide

### Clone this Repo

```bash
git clone https://github.com/sporule/big-data-cluster
cd big-data-cluster/
```

### Run the whole cluster

```bash
docker-compose up -d
```

### Run Individual Contaier

You can run individual container by using Docker command, please find more information and tutorial on Docker website. Please remember to pass environment variables to the Docker command. You can find the relevant environment variables in the *docker-compose.yml* file.


## What is included


### Components

| Components       | Version | Included | Container         | Port (external:internal)               |
| ---------------- | ------- | -------- | ----------------- | -------------------------------------- |
| Apache Hadoop    | 3.1.1   | Y        | Master,Worker,Dev | Yarn: 10001:10086, DateNode:10000:9870 |
| Apache Hive      | 3.1.0   | Y        | Master,Worker,Dev |                                        |
| Apache Kafka     | 2.0.0   | Y        | Master            |                                        |
| Apache Spark     | 2.4.6   | Y        | Master, Dev       | History Server:10002:9999              |
| Apache ZooKeeper | 3.4.6   | Y        | Master            |                                        |
| Apache Airflow   | 1.10.10 | Y        | Master, Dev       | 10003:8083                             |
| Jupyter Hub      | 1.1.0   | Y        | Dev               | 10010:8080                             |
| Apache Nifi      | 1.1.4   | Y        | Dev               | 10011:8081                             |
| Apache Livy      | 0.5.0   | Y        | Dev               | 10014:8998                             |

### Containers in Docker-Compose by default

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



### User Configuration 

In **hadoop.env**, you can find a variable call USERS. This is the place for you to enter your usernames which will be created in dev-nodes.
You can also set default password in the variable USERS_PASSWORD.



### Application On or Off Configuration

You can turn on or off some applications by using environment variables, **0** means on and **1** means off. You can update the environment variable in the **hadoop.env** file or inject it while starting the containers (through Docker command or docker-compose.yml). However, it is good to note that **hadoop.env** will have lower priority. current supported applications are:

| Name      | Environment Variable | Default |
| --------- | -------------------- | ------- |
| Airflow   | AIRFLOW              | 0       |
| Zookeeper | ZOOKEEPER            | 0       |
| Kafka     | KAFKA                | 0       |
| Nifi      | NIFI                 | 0       |
| Jupyter   | NIFI                 | 1       |
| Livy      | LIVY                 | 0       |