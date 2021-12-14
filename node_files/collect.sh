#!/bin/bash
while true; do
path=`pwd`
source $path/node.conf
# Make working paths, if not already present
if [ ! -d "$path/output" ]; then
	mkdir $path/output;
fi

if [ ! -d "$path/working" ]; then
        mkdir $path/working;
fi
output=$path/output/$(date +%Y%m%d_%H%M%S)
# WifiSTA
if [[ $WifiSTA_Active == 1 ]]; then
        echo NodeID=$NodeID >> $output"_WifiSTA_details"
        echo ScanType=Wifi_STA >> $output"_WifiSTA_details"
        # Run base wifi collection
        timeout --foreground $CollectInterval airodump-ng hdw0 -w $path/working/airo --output-format csv > /dev/null 2>&1
        while read line; do echo $line | cut -d ',' -f 1; done < $path/working/airo-01.csv > $path/working/temp_list
        # Parse results for WifiSTA
        tac $path/working/temp_list | sed '/Station MAC/q' | grep -v "BSSID\|Station" | sort -u > $output"_WifiSTA_list"
        dos2unix $output"_WifiSTA_list" > /dev/null 2>&1
        sed -i '/^$/d' $output"_WifiSTA_list"
        # Report geo coordinates and collection time
        gpspipe -w -n 10 | grep -m 1 lon > $path/working/temp_gps
        echo gps_lat=$(cut -d ":" -f 9 $path/working/temp_gps | cut -d "," -f 1) >> $output"_WifiSTA_details"
        echo gps_lon=$(cut -d ":" -f 10 $path/working/temp_gps | cut -d "," -f 1) >> $output"_WifiSTA_details"
        echo ObservedTime='"'`stat $path/working/airo-01.csv | grep Change | cut -d "." -f 1 | sed -e "s/Change: //g"`'"' >> $output"_WifiSTA_details"
fi
# WifiAP
if [[ $WifiAP_Active == 1 ]]; then
        echo NodeID=$NodeID >> $output"_WifiAP_details"
        echo ScanType=Wifi_AP >> $output"_WifiAP_details"
        if [[ ! -f $path/working/temp_list ]]; then
                # Run base wifi collection (if the list doesn't exist already)
                timeout --foreground $CollectInterval airodump-ng hdw0 -w $path/working/airo --output-format csv > /dev/null 2>&1
                while read line; do echo $line | cut -d ',' -f 1; done < $path/working/airo-01.csv > $path/working/temp_list
        fi
        # Parse results for WifiAP
        sed '/Station MAC/q' $path/working/temp_list | grep -v "BSSID\|Station" | sort -u > $output"_WifiAP_list"
        dos2unix $output"_WifiAP_list" > /dev/null 2>&1
        sed -i '/^$/d' $output"_WifiAP_list"
        # Report geo coordinates and collection time
        gpspipe -w -n 10 | grep -m 1 lon > $path/working/temp_gps
        echo gps_lat=$(cut -d ":" -f 9 $path/working/temp_gps | cut -d "," -f 1) >> $output"_WifiAP_details"
        echo gps_lon=$(cut -d ":" -f 10 $path/working/temp_gps | cut -d "," -f 1) >> $output"_WifiAP_details"
        echo ObservedTime='"'`stat $path/working/airo-01.csv | grep Change | cut -d "." -f 1 | sed -e "s/Change: //g"`'"' >> $output"_WifiAP_details"
fi
# Bluetooth
if [[ $BT_Active == 1 ]]; then
        echo NodeID=$NodeID >> $output"_BT_details"
        echo ScanType=BT >> $output"_BT_details"
        # Run bluetooth scan
        bluetoothctl --timeout $CollectInterval scan on > $path/working/bt_scan
        # Parse results for BT scan
	grep -E "[CHG]|[NEW]" $path/working/bt_scan | cut -d ' ' -f 3 | sort -u > $output"_BT_list"
        dos2unix $output"_BT_list" > /dev/null 2>&1
        sed -i '/^$/d' $output"_BT_list"
        # Report geo coordinates and collection time
        gpspipe -w -n 10 | grep -m 1 lon > $path/working/temp_gps
        echo gps_lat=$(cut -d ":" -f 9 $path/working/temp_gps | cut -d "," -f 1) >> $output"_BT_details"
        echo gps_lon=$(cut -d ":" -f 10 $path/working/temp_gps | cut -d "," -f 1) >> $output"_BT_details"
        echo ObservedTime='"'`stat $path/working/bt_scan | grep Change | cut -d "." -f 1 | sed -e "s/Change: //g"`'"' >> $output"_BT_details"
fi
rm -rf $path/working/*;
sleep $CollectInterval;
done