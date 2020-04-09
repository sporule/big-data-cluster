#!/bin/bash

echo "export PATH=$PATH" >> "/root/.profile"
echo "export JAVA_HOME=$JAVA_HOME" >> "/root/.profile"
echo "export HADOOP_VERSION=$HADOOP_VERSION" >> "/root/.profile"
echo "export HADOOP_HOME=$HADOOP_HOME" >> "/root/.profile"
echo "export HADOOP_CONF_DIR=$HADOOP_CONF_DIR" >> "/root/.profile"
echo "export HIVE_HOME=$HIVE_HOME" >> "/root/.profile"
echo "export HIVE_VERSION=$HIVE_VERSION" >> "/root/.profile"

service ssh restart && bash

tail -f /dev/null
