#!/bin/bash

echo "export PATH=$PATH" >> "/etc/profile"
echo "export JAVA_HOME=$JAVA_HOME" >> "/etc/profile"
echo "export HADOOP_VERSION=$HADOOP_VERSION" >> "/etc/profile"
echo "export HADOOP_HOME=$HADOOP_HOME" >> "/etc/profile"
echo "export HADOOP_CONF_DIR=$HADOOP_CONF_DIR" >> "/etc/profile"
echo "export HIVE_HOME=$HIVE_HOME" >> "/etc/profile"
echo "export HIVE_VERSION=$HIVE_VERSION" >> "/etc/profile"
echo "export SPARK_HOME=$SPARK_HOME" >> "/etc/profile"
echo "export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH" >> "/etc/profile"
echo "export PYSPARK_PYTHON=python3" >> "/etc/profile"
echo "export PYTHONIOENCODING=utf8" >> "/etc/profile"

# Link hive config to spark conf
ln -s /opt/hive/conf/hive-site.xml /spark/conf/hive-site.xml

# Run Airflow if it is enabled
if [ "$AIRFLOW" = "1" ]; then airflow initdb; (airflow webserver -p 8083 &) ;(airflow scheduler &); fi

# Run Jupyter Lab if it is enabled
if [ "$JUPYTER" = "1" ]; then (jupyter lab --ip 0.0.0.0 --allow-root --NotebookApp.token=$JUPYTERTOKEN --port 8080 &) ; fi

# Run Jupyter Lab if it is enabled
if [ "$NIFI" = "1" ]; then (service nifi start) ; fi

# Run Livy  if it is enabled
if [ "$LIVY" = "1" ]; then (/livy/bin/livy-server start) ; fi

# Add Spark Logs folder
hadoop fs -mkdir /spark-logs &


# Add Users

function add_users(){
  for name in ${USERS[@]}
  do
        adduser $name --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password --force-badname
        echo "$name:$USERS_PASSWORD" | chpasswd
        usermod -a -G root $name
  done
}

add_users &


# Start SSH
service ssh restart && bash

tail -f /dev/null
