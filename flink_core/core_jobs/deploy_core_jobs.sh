#!/bin/bash

echo Deploying core jobs...

zookeeperUrl=zookeeper1:2181
namespace=ns1
DS_NAME=datalake
JM_HOST=jobmanager:8081
FLINK_ROOT=/opt/flink
FLINK_CONF_DIR=$FLINK_ROOT/conf
JOB_JAR=$FLINK_ROOT/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar

echo Deploying StreamSourceJob...

flink run -d -c com.prudential.platform.services.data.stream.CDCStreamSourceJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf /opt/flink/conf/scripts/cdc.json --src LifeAsia --checkpoint true

echo Deploying Transform Job...

flink run -d -c com.prudential.platform.services.data.stream.CDCStreamTransformationJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf /opt/flink/conf/scripts/cdc.json --parallelism 3 --checkpoint true

echo Deploying LoadJob...

flink run -d -c com.prudential.platform.services.data.stream.CDCStreamLoadJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf /opt/flink/conf/scripts/cdc.json --parallelism 3 --checkpoint true
