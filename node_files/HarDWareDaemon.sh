#!/bin/bash
hdw_node_path=/hdw
cd $hdw_node_path
# Check if HDW is running
if [[ ! -z `sudo screen -ls | grep -E "HDW Checkin|HDW Collect|HDW Report"` ]]; then 
    clear;
    echo "[!] HDW is running!"; sudo screen -ls | grep -E "HDW Checkin|HDW Collect|HDW Report"; 
else
    sudo rm -rf $hdw_node_path/working
    sudo screen -S "HDW Checkin" -d -m bash -c "./checkin.sh >/dev/null 2>&1"
    sudo screen -S "HDW Collect" -d -m bash -c "./collect.sh >/dev/null 2>&1"
    sudo screen -S "HDW Report" -d -m bash -c "./report.sh >/dev/null 2>&1"
fi