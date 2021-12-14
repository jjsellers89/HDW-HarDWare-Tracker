#!/bin/bash
while true; do
path=`pwd`;
source $path/node.conf;
# iterate through output directory
if [[ `curl $heartbeat_URL 2>/dev/null` == "Reachable" ]]; then
	for i in `ls $path/output | grep "_details"`; do 
		b=`echo $i | cut -d " " -f 1`;
		collect_time=$(echo $b | cut -d "_" -f -2);
		source $path/output/$b; 
		list=`echo $path/output/$b | cut -d "_" -f -4`_list;
		#ReportedTime=$(date "+%F %H:%M:%S"); # this is taken care of by the NOW() in SQL query (server side)
		if `echo $b | grep STA > /dev/null`; 
			then ScanType="Wifi_STA";
		elif `echo $b | grep AP > /dev/null`; 
			then ScanType="Wifi_AP";
		elif `echo $b | grep BT > /dev/null`;
			then ScanType="BT";
		fi
		if [[ ! -z $NodeID && ! -z $ScanType && ! -z $ObservedTime && ! -z $gps_lat && ! -z $gps_lon ]]; then # this will prevent empty data sets from trying to post
			if while read ObservedSelector; do curl -k -X POST -F "NodeID=$NodeID" -F "SelectorType=$ScanType" -F "ObservedSelector=$ObservedSelector" -F "ObservedTime=$ObservedTime" -F "gps_lat=$gps_lat" -F "gps_lon=$gps_lon" $report_URL -A "HDW Node$NodeID"; done < $list > /dev/null 2>&1; then 
				rm $path/output/$b; # delete details
				rm $list; # delete list
			fi
		fi
	done
fi
sleep $ReportInterval;
done