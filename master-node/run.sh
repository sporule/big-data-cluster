#!/bin/bash

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
if [ ! -d $namedir ]; then
  echo "Namenode name directory not found: $namedir"
  exit 2
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

if [ "`ls -A $namedir`" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME 
fi

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

function check_precondition(){
  for i in $@
  do
        wait_for_it ${i}
  done
}



echo "starting namenode"
(while true; do 
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode 
done) &

echo "starting resource manager"

(while true; do 
    check_precondition $RESOURCE_MANAGER_PRECONDITION
    $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
done) &




echo "starting history server"
(while true; do 
  check_precondition $HISTORY_SERVER_PRECONDITION
  $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver
done) &


echo "starting hive metastore"
check_precondition $HIVE_METASTORE_PRECONDITION
/opt/hive/bin/hive --service metastore &

echo "starting hive server 2"
hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse
check_precondition $HIVE_SERVER_PRECONDITION
cd $HIVE_HOME/bin
./hiveserver2 --hiveconf hive.server2.enable.doAs=false &

tail -f /dev/null