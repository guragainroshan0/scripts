#!/bin/bash

showHelp(){
	cat << EOF
Usage: $0 [-hip]
	Displays ip address associated with a interface and public IP of the machine.
	
	Both -h and -i are optional.
	
	-h,--help      	: Shows Help
	-i,--interface 	: Specify Interface Name to get IP address of the specific interface
	-p,--public     : Get the public IP address only
		
EOF

}

function get_public_ip(){

	echo "Public IP : $(curl -s ifconfig.me)"
}


function interface_ip(){
	get_interface_ip | grep "$1" | awk '{print $2}'
}

function get_interface_ip(){

echo -e "Interface \t\t\t IP"
for i in $(ls /sys/class/net/)
do
	ips=$(ip a s $i | grep scope | awk '{print $2}')
	if [ ! -z "$ips" ]; 
		then
			for ip in $ips
				do
					ip=$(echo $ip | cut -d "/" -f 1)
					echo -e "$i \t\t\t $ip"
				done
	fi
done
exit 0 
}

options=$(getopt -l "help,interface,public" -o "hip" -- "$@")
eval set -- "$options"
while true
do
	case "$1" in
		-h|--help)
			showHelp
			exit 0
			;;
	    -i|--interface)			
		 	shift	
			interface_ip $2
			exit 0 
			;;
	        -p|--public)
			get_public_ip
			exit 0
			;;
		--)
			shift
			break
	esac
	shift
		
done	
get_public_ip		
get_interface_ip
