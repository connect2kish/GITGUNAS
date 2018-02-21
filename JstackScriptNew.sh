#Usage : ./JstackSeries.sh 1254 1000 30 &  [background] or ask customer to run as cron job
#!/bin/bash

if [ $# -eq 0 ]; then
    echo >&2 "Usage: jstackSeries  [ count [ delay ] ]"
    echo >&2 "    Defaults: count = 10, delay = 1 (seconds)"
    exit 1
fi

pid=$1          # required
count=${2:-10}  # defaults to 10 times
delay=${3:-1} # defaults to 1 second

while [ $count -gt 0 ]
do
<INFA_HOME>/tools/debugtools/java/bin/jstack $pid > /tmp/jstack.$pid.$(date +%H%M%S.%N)
<INFA_HOME>/tools/debugtools/java/bin/jcmd $pid VM.native_memory baseline
<INFA_HOME>/tools/debugtools/java/bin/jcmd $pid VM.native_memory detail.diff > /tmp/JVM_Native_detail_diff.$pid.$(date +%H%M%S.%N).log
<INFA_HOME>/tools/debugtools/java/bin/jmap -heap $pid > JmapHeap.$pid.$(date +%H%M%S.%N)
top -b -n 1 > /tmp/top.$(date +%H%M%S.%N)
top -n 1 -bHp $pid > /tmp/topHP_DIS.$pid.$(date +%H%M%S.%N)
	 
	sleep $delay
    let count--
    echo -n "."
done