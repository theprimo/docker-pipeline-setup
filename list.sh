#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Valid Options are"
  echo "1. fixperm"
  echo "2. list_jobs"
  echo "3. osjobs"
  echo "4. dljobs"
  echo "5. cancel all jobs"
  exit
fi

## VARIABLE Declaration
export SCRIPTS_PATH=/opt/flink/conf/scripts
export CLASS=com.prudential.platform.services.data.stream

function fixperm {
   chown -R flink:flink /opt/flink/log
   chown -R flink:flink /opt/flink/log/state_dir

}
function list_jobs {
 echo "flink list -r"
 flink list -r
}

function os_jobs {
  echo "deploying os-dl jobs"
  gosu flink flink run -d -c $CLASS.CDCStreamSourceJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf $SCRIPTS_PATH/os_dl/cdc_OS.json --src OS --checkpoint true --parallelism 1
  sleep 30
  gosu flink flink run -d -c $CLASS.CDCStreamTransformationJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf $SCRIPTS_PATH/os_dl/cdc_OS.json --checkpoint true --parallelism 12
  sleep 30
  gosu flink flink run -d -c $CLASS.CDCStreamLoadJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf $SCRIPTS_PATH/os_dl/cdc_OS.json  --checkpoint true --parallelism 12
  sleep 30

  echo "Job Deployment Completed"
}

function dl_jobs {
  echo " deploy dl jobs"
  gosu flink flink run -d -c $CLASS.CDCStreamSourceJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf $SCRIPTS_PATH/dl_il/cdc_IL_STG.json --src OS --checkpoint true --parallelism 1
  sleep 30
  gosu flink flink run -d -c $CLASS.CDCStreamTransformationJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf $SCRIPTS_PATH/dl_il/cdc_IL_STG.json --checkpoint true --parallelism 12
  sleep 30
  gosu flink flink run -d -c $CLASS.CDCStreamLoadJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf $SCRIPTS_PATH/dl_il/cdc_IL_STG.json  --checkpoint true --parallelism 12
  sleep 30
}

function cancel_jobs {
  echo "cancelling all jobs"
  jobs=$(flink list -r | cut -d ':' -f4 | grep -Ev 'Wa|-')
  for i in ${jobs[@]}; do flink cancel $i; done
}

function cancel_jobs_with_savepoint {
  echo "cancelling all jobs"
  jobs=$(flink list -r | cut -d ':' -f4 | grep -Ev 'Wa|-')
  for i in ${jobs[@]}; do flink cancel $i -s ; done
}
case "$1" in

1) echo "fix  permission"
     fixperm
    ;;

2)  echo "List Running Jobs"
    list_jobs
    ;;
3)  echo  "Deploying OS to DL jobs"
    os_jobs
    ;;
4)  echo  "Deploying DL_IL jobs"
    dl_jobs
    ;;
5)  echo  "Cancelling all jobs"
    cancel_jobs
    ;;
6)  echo  "Cancelling all jobs"
    cancel_jobs_witj_savepoint
    ;;

*) echo "Signal number $1 is not processed"
   ;;
esac
