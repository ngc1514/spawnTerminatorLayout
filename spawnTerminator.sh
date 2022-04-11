#!/bin/bash

# init env var
if ! grep -Fq "boxName=" ~/.zshenv
then
	echo "Initializing environment variable \"boxName\""
	echo -e "boxName=" >> ~/.zshenv
	source ~/.zshenv
fi

if ! grep -Fq "boxIP=" ~/.zshenv
then
	echo "Initializing environment variable \"boxIP\""
	echo -e "boxIP=" >> ~/.zshenv
	source ~/.zshenv
fi


boxNameArg=$1
boxIPArg=$2


function spawning() {
	boxDir="$HOME/HTB/$boxName"
	echo "spawning: $boxDir"

	# Directory exists, CD to that dir
	if [ -d "$boxDir" ]; then
		echo "Directory ${boxDir} already exists. Changine directory."
	else
		echo "Creating directory $boxDir"
		mkdir -p $boxDir
	fi
	echo "Spawning layout htb for \"$boxName\"..."
	terminator -l htb
}

function quitAndReset(){
	sed -i "s/boxName=.*/boxName=/g" ~/.zshenv
	sed -i "s/boxIP=.*/boxIP=/g" ~/.zshenv
	source ~/.zshenv
	echo "Unsetting info. Quitting..."
	exit 0;
}


# Usage message
if [[ "$#" = 0 ]] || [[ "$#" > 2 ]]; then
	echo -e "Example 1: ./spawnHTB.sh yourBoxName 
	\nExample 2: ./spawnHTB.sh yourBoxName 
	\nExample 3: ./spawnHTB.sh yourBoxName yourBoxIP
	\nQuitting."


# Confirm and call spawning()  
elif [[ "$#" -ge 1 ]] || [[ "$#" -le 2 ]]; then
	# set env var boxName in .zshenv and source the file
	sed -i "s/boxName=.*/boxName=$boxNameArg/g" ~/.zshenv
	source ~/.zshenv
	echo "New boxName: $boxName"
	message1="Confirm box name \"$boxName\"? [y/N]"

	# if IP is entered, store IP to env var
	if [[ "$#" = 2 ]]; then
		if [[ $boxIPArg =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
			sed -i "s/boxIP=.*/boxIP=$boxIPArg/g" ~/.zshenv
			source ~/.zshenv
			echo "Box IP: $boxIPArg"
			message1="Confirm box name \"$boxName\" and IP \"$boxIP\"? [y/N]"
		else
			echo "Invalid IP format!"
			quitAndReset
		fi
	fi

	# confirm
	read -r -p "$message1" response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		spawning
	# cancel and unset env var
	else
		quitAndReset
	fi
fi
