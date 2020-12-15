#!/bin/sh


#info
info(){
	cat<<EOF
Checks if APACHE,MySQL server and PHP exists on the system. If not installs them and has a function to create mysql database
EOF

}
#check root permission
check_root(){
	echo $EUID
	if ! [ $(id -u) = 0 ];
	then
		echo "[-] Root permissions needed."
		exit 1
	fi
}

install_software(){
	check_root
	 apt install $1 -y
}

#test for installed software
check_installed(){
	
	#use dpkg to check for installed software
	check=$(dpkg -l $1 | tail -1 | cut -d " " -f 3)
	if [ "$check" = "$1" ]
	then
		echo "[+] $1 is installed"
		installed=1
	else
		echo "[+] Installing $1 "
		install_software $1
		installed=0

	fi

}

#Run sql command and check for error
sql_command(){
	
	#Redirect stderr to stdout. Took a lot of time to figure out
	val=$(eval $1 2>&1)
	#check if error is there on the output
	test=$(echo $val | grep "ERROR")
	
	if  [ ! -z "$test" ]
	then
		echo "[-] Failed executing\n : $1"
		echo "[-] Error :\n $val"
		echo "[-] Exitting"
		exit 1
	fi
	
}


#Test if the database exists
test_database_existence(){
	# show databases dumps databases and grep the same name as user wants to createe
	db=$( mysql -e "show databases" | grep "^$1$")
	
	#if the same database is found db is not empty.
	if [ -z "$db" ]
		then
			echo "[+] Creating database $1"
			sql_command 'mysql -e "Create database '$1';"'
		else
			echo "[-] Database $1 Exists. Exitting"			
			exit 1
	fi
}

#test if the user with same name exists
test_user_existence(){

	#Same with the database logic
	user=$(mysql -e "SELECT User from mysql.user;" | grep "^$1$")

	if [ -z "$user" ]
		then
			#create user and grant privilege on the created database
			echo "[+] Creating user "
			 sql_command 'mysql -e "FLUSH PRIVILEGES;"'
			 sql_command 'mysql -e "CREATE USER '$1'@localhost IDENTIFIED BY '\'$2\'';"'
			 sql_command 'mysql -e "GRANT ALL PRIVILEGES on '$3'.'*' to '$1'@localhost;"'
			 sql_command 'mysql -e "FLUSH PRIVILEGES;"'
		else
			echo "[-] User $1 exists.Exitting"
			exit 1
			
	fi

}

#creates mysql user
create_mysql_user(){
	#root permission needed so testing is done here
	check_root

	echo "Enter Name of User You want to create: "
	read user_name
	echo "Enter Database Name"
	read database_name
	echo "Enter User's Password"
	read user_pass

	test_database_existence $database_name
	test_user_existence $user_name $user_pass $database_name
	
	echo "[+] Database successfully created. You may now login with\n Username: $user_name\nPassword: $user_pass."
	cat<<EOF
	mysql -u $user_name -p 
EOF
	
	

}

info
#test for apache
check_installed apache2
check_installed mysql-server
check_installed php

echo "Do you want to create a new user and database?[y/n]  "
read var
if [ "$var" = "y" ]
then
create_mysql_user
fi
