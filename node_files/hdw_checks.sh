#!/bin/bash
# hdw0 will be configured as the hdw nic
source `pwd`/hdw_checks.sh
### GPS 
echo -e "[+] Checking GPS settings"
systemctl stop gpsd
systemctl stop gpsd.socket
kill -9 `pidof gpsd` >/dev/null 2>&1
gpsd -n -D 5 /dev/ttyUSB0
gpspipe -w -n 5 /dev/ttyUSB0 >/dev/null 2>&1 && echo -e "[.] GPS working"
#
### Bluetooth 
echo -e "[+] Checking if Bluetooth is running"
bluetoothctl power on >/dev/null 2>&1 && echo -e "[.] Bluetooth is on"
#
### WiFi
echo -e "[+] Configuring hdw0 (changing MAC and setting monitor mode)"
ip link set hdw0 down
macchanger -r hdw0
iw dev hdw0 set type monitor
ip link set hdw0 up
iw dev hdw0 info | grep -E "addr|type"
#
### Check HDW Server
echo -e "[+] Checking if HDW server is reachable"
curl $heartbeat_URL -A "HDW on-boot test $NodeID" || echo -e "[!] Unable to reach HDW server, check connectivity"