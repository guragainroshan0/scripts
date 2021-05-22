#!/bin/bash

# not tested yet 
# will test if i have to do the similar work again
# needs python3, pip3 and firefox packages, pip3 requires python3-pip to install so didnot add in the array
packages=(python3 firefox screen)

# loop through the packages to install
for pkg in $packages
do
	# check if packages exists
	which $pkg > /dev/null 2>&1

	# if the package exits exit status ($?) is set to 0  and if not 1
	if [ $? != 0 ]
	then
		sudo apt install $pkg
	fi
done

# check for pip3 as it needs to be installed using python3-pip
which pip3 > /dev/null 2>&1

if [ $? != 0 ]
then
	sudo apt install python3-pip
fi

# install the requirements
pip3 install -r requirements.txt

# copy the geckodriver binary to the path
cp geckodriver /usr/bin/geckodriver

# run the scraper in screen sessions
screen -S RUN -m -d python3 run.py
screen -S SEND -m -d python3 send.py
