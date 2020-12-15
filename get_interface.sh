#!/bin/bash

showHelp(){

# cat to print the help 
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
#curl the ifconfig.me site -s for silent as it prints more
	echo "Public IP : $(curl -s ifconfig.me)"
}


function interface_ip(){
	#get_interface_ip gets all the interface and their ip address, get user specified interface $1 and grep from total list. AWK to get the ip address only
	get_interface_ip | grep "$1" | awk '{print $2}'
}

function get_interface_ip(){

echo -e "Interface \t\t\t IP"

#/sys/class/net has all the interfaces on the machine. loop through it
for i in $(ls /sys/class/net/)
do
	#grep scope as the line containing this has a for address s for interface $i is from the /sys/class/net
	#get the ip address usin awk both ipv4 and ipv6
	ips=$(ip a s $i | grep scope | awk '{print $2}')
	
	#if some interface does not have Ip assigned discard these interface. -z to check if $ips is empty
	if [ ! -z "$ips" ]; 
		then
			#loop through multiple ip addressess
			for ip in $ips
				do
					#remove CIDR notation
					ip=$(echo $ip | cut -d "/" -f 1)

					#print with tabs
					echo -e "$i \t\t\t $ip"
				done
	fi
done
exit 0 
}

#for the arguments --help,--interface,--pubic
options=$(getopt -l "help,interface,public" -o "hip" -- "$@")
eval set -- "$options"

#looping through if multiple arguments are given
while true
do
	case "$1" in
		-h|--help)
			showHelp
			exit 0
			;;
	    -i|--interface)
			#shifts the argument by 1 i.e $2 becomes $1			
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
#if no arguments are given show all data	
get_public_ip		
get_interface_ip
