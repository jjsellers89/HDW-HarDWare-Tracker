#!/bin/bash
while true; do
source `pwd`/node.conf 
test_result=`curl $heartbeat_URL 2>/dev/null`
if [[ $test_result == "Reachable" ]]; then 
	curl $checkin_URL 1> .node.conf 2>/dev/null; 
	if grep -e "^NodeID" -e "^CollectInterval" -e "^ReportInterval" -e "^CheckinInterval" -e "^WifiSTA_Active" -e "^WifiAP_Active" -e "^BT_Active" -e "^heartbeat_URL" -e "^checkin_URL" -e "^report_URL" ./.node.conf; then 
		mv -vf ./.node.conf ./node.conf
	else
		rm -v ./.node.conf
	fi
fi
sleep $CheckinInterval;
done