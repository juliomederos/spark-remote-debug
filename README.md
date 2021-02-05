# spark-remote-debug

POC Spark remote debug

---

## Prerequisites

- Cluster

Create a cluster following the instructions in https://github.com/juliomederos/docker-spark-yarn-cluster

Local machine: 
	- IntelliJ
	- jq
	- ssh
	- scp

---

### Debug steps

create jar -> move jar into cluster -> run with debug paramters -> debug 

### Manual 

```
# create jar
sbt clean assembly

2. move jar into the cluster
TODO

3. run with debug parameters
TODO

4. redirect remote port into local machine
TODO
```

5. debug

TODO show the application in YARN with the trace saying the debug port is available.

TODO copy parameters from IntelliJ

### Automatic

To debug in the cluster multiple times it is useful to automate the steps.

```
# Creates the jar, transfer it into the cluster, run spark-submit with debug parameters
run_step.sh package transfer spark_submit 
```

```
# Makes available the remote port locally
run_step.sh porf_forwarding
```

IDE configuration:

TODO

