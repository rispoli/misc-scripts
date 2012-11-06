#!/bin/bash

# $1: image url
# $2: refresh rate

logfile=/tmp/webcam.log

while [ 1 ]
do

	of=`date +%Y.%m.%d_%H.%M.%S`.jpg
	
	{ time wget $1 -O $of; } 2> $logfile

	download_time=`cat $logfile | grep real | sed -e 's/.*0m\(.\+\)s/\1/'`
	
	wait_time=`echo "$2 - $download_time" | bc`

	echo "Saved $of in $download_time seconds, waiting $wait_time"
	sleep $wait_time

done
