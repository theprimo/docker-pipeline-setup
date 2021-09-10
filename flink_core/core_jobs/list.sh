#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Valid Options are"
  echo "1. fixperm"
  echo "2. list_jobs"
  echo "3. jobs"
  echo "5. cancel all jobs"
  exit
fi

## VARIABLE Declaration
export SCRIPTS_PATH=/opt/flink/conf/scripts
export CLASS=com.prudential.platform.services.data.stream

function fixperm {
   chown -R flink:flink /opt/flink/log
   chown -R flink:flink /opt/flink/state_dir

}
function list_jobs {
 echo "flink list -r"
 flink list -r
}

function jobs {
  echo "deploying  jobs"
  
  flink run -d -c com.prudential.platform.services.data.stream.CDCStreamSourceJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf /opt/flink/conf/scripts/cdc.json --src LifeAsia --checkpoint true
  sleep 30
  flink run -d -c com.prudential.platform.services.data.stream.CDCStreamTransformationJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf /opt/flink/conf/scripts/cdc.json --parallelism 3 --checkpoint true
  sleep 30
  flink run -d -c com.prudential.platform.services.data.stream.CDCStreamLoadJob /opt/flink/core_jobs/flink-core-jobs-0.0.7-SNAPSHOT.jar --conf /opt/flink/conf/scripts/cdc.json --parallelism 3 --checkpoint true


  echo "Job Deployment Completed"
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
3)  echo  "Deploying jobs"
    jobs
    ;;
5)  echo  "Cancelling all jobs"
    cancel_jobs
    ;;
6)  echo  "Cancelling all jobs"
    cancel_jobs_with_savepoint
    ;;

*) echo "Signal number $1 is not processed"
   ;;
esac
