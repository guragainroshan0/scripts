#!/bin/sh

info(){
	cat<<EOF
Run the script to host files using apache. Creates a config on which document_root points to the folder to host the file.
EOF
}

clean(){
 rm /etc/apache2/sites-available/script_file.conf /etc/apache2/sites-enabled/script_file.conf 2>/dev/null
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

#checks installed software
check_installed(){          
                                                       
        #use dpkg to check for installed software 
        check=$(dpkg -l $1 | tail -1 | cut -d " " -f 3)
        if [ "$check" = "$1" ]                              
        then                                                                                                                
                echo "[+] $1 is installed"                           
        else                        
                echo "[+] Install $1 first. " 
		echo "[+] Run sudo apt install apache2"                           
        fi

}

create_config(){
	check_root
	FILE=$1
	PORT=$2
	if [ ! -f $1 ]
	then
		echo "[+] Enter Filename"
		exit 1
	fi
	mkdir /var/www/html/script_files/ 2>/dev/null
	cp $1 /var/www/html/script_files
	#chmod -R 777 /tmp/script/
	cat>/etc/apache2/sites-available/script_file.conf <<EOF
Listen $2
<VirtualHost *:$PORT>
	DocumentRoot /var/www/html/script_files/
	<Directory /var/www/html/script_files>
		Options +Indexes
	</Directory>
</VirtualHost>
EOF
	ln -s /etc/apache2/sites-available/script_file.conf /etc/apache2/sites-enabled/script_file.conf
	echo$(systemctl restart apache2)
}

info
clean
check_installed apache2
create_config $1 $2 
