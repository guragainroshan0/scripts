#!/bin/bash

nmap_updated(){
	echo $1 $2 $3
	local ip=$1
	local out=$2
	local additional_param=$3
	if [ "$1" == "-h" ]
		then
			echo "$0 <ip-address> <directory-to-store> [<additional-parameters>]"
			exit 0
	fi

	if [ $# -lt 2 ]; then
		echo "At least two arguments needed. -h for help."
		exit 1
	fi
		
	if [[ $EUID -ne 0 ]];then
		echo "Root Permission Needed"
		exit 1
	else
		echo "nmap -sC -sS -A $1 $3 -o '$2/nmap_$1'"
		nmap -sC -sS -A $1 $3 -o $2/nmap_$1
	fi
	
}


nmap_updated $1 $2 "$3" 
