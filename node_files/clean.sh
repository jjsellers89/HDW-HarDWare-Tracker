#!/bin/bash
#
clear
echo -ne "[-] Are you sure you want to delete these directories? (you may have data that has not been posted yet)\nAnswer (Y)es or (N)o: "; read -n 2 ans
if [[ $ans = [Yy] ]]
then  
	echo "[+] Removing output and working directories..."
	sudo rm -rvf output working
elif [[ $ans = [Nn] ]]
then
        echo "This script will NOT remove the directories."
else
	echo "Unable to determine your answer, doing nothing."
fi