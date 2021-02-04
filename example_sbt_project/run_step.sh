#!/bin/bash

ssh_user="root"
remote_machine="mycluster-master"
local_debug_port=5006
remote_debug_port=5006
yarn_endpoint="http://$remote_machine:8088/ws/v1/cluster"
remote_output_path="/tmp"

package () {

    step="package"

    echo "STARTED step: $step"

    sbt clean assembly
    rc=$?

    if [ $rc -ne 0 ] ; then
        echo "FAILED step: $step"; exit $rc
    fi

    echo "FINISHED step: $step"

}

transfer () {

    step="transfer"

    prj_name=$(sbt -no-colors name | tail -1 | cut -d ' ' -f 2)
    prj_version=$(sbt -no-colors version | tail -1 | cut -d ' ' -f 2)
    file=$prj_name"-assembly-$prj_version.jar"

    echo "STARTED step: $step"
    echo "Copying $file into remote machine path: $remote_output_path"

    # Deploying files
    scp -o "StrictHostKeyChecking no" -r ./target/scala-2.11/$file $ssh_user@$remote_machine:$remote_output_path/
    rc=$?
    if [ $rc -ne 0 ] ; then
      echo "FAILED step: $step"; exit $rc
    fi

    echo "FINISHED step: $step"

}

spark_submit () {

    step="run"

    echo "STARTED step: $step"

    prj_name=$(sbt -no-colors name | tail -1 | cut -d ' ' -f 2)
    prj_version=$(sbt -no-colors version | tail -1 | cut -d ' ' -f 2)
    file=$prj_name"-assembly-$prj_version.jar"

    app_name="DemoApp"
    cmd_spark_submit="spark-submit --master yarn --deploy-mode cluster --driver-memory 1G --conf spark.executor.cores=1 --conf spark.dynamicAllocation.enabled=false --conf spark.executor.memory=1G --conf spark.yarn.maxAppAttempts=1 --conf spark.executor.instances=1 --driver-java-options \"-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=$remote_debug_port\" --class $app_name $remote_output_path/$file"

    echo $cmd_spark_submit

    ssh -o "StrictHostKeyChecking no" $ssh_user@$remote_machine -- $cmd_spark_submit

    echo "FINISHED step: $step"

}

port_forward () {

    application_master=$(curl -L "$yarn_endpoint/apps/?user=$ssh_user&state=ACCEPTED&limit=1" | jq -r '.apps.app[0].amHostHttpAddress' | cut -d':' -f 1)
    echo ">>> Application master : $application_master"

    # Tunneling between 3 machines (localhost <- master-node <- slave-node) 
    ssh $ssh_user@$remote_machine -N -f -L "$local_debug_port:$application_master:$remote_debug_port"
}

 for step in $*; do
   echo "Step: $step"

    if [ $step = "package" ]; then
            package
    elif [ $step = "transfer" ]; then
            transfer
    elif [ $step = "spark_submit" ]; then
            spark_submit
    elif [ $step = "port_forward" ]; then
            port_forward
    else
            echo "$step is not valid step"
    fi

 done

