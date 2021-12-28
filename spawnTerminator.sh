#!/bin/bash

boxNameArg=$1
confirm=$2

function spawning() {
	DIR="~/HTB/$boxName"
	echo "spawning: $DIR"
	if [ -d "$DIR" ]; then
		echo "Directory $Dir exists. Changine directory."
	else
		echo "Creating directory ~/HTB/$boxName"
		mkdir ~/HTB/$boxName
	fi

	echo "Spawning layout htb for $boxName"
	terminator -l htb
}

if [[ "$#" = 0 ]] || [[ "$#" > 2 ]]; then
	echo -e "Example 1: ./spawnHTB.sh yourBoxName \nExample 2: ./spawnHTB.sh yourBoxName -y \nQuitting."


elif [[ "$#" = 1 ]] || [[ "$#" = 2 ]]; then

	# set env var boxName in .zshenv and source the file
	echo "argument is: $boxNameArg"
	sed -i "s/boxName=.*/boxName=$boxNameArg/g" ~/.zshenv
	source ~/.zshenv
	echo "New boxName: $boxName"

	if [[ "$#" = 2 ]] && [[ "$2" == "-y" ]]; then
		spawning

	else
		read -r -p "Confirm box name: $boxName? [y/N]" response
	
		if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
			spawning
		# cancel and unset env var
		else
			sed -i "s/boxName=.*/boxName=/g" ~/.zshenv
			source ~/.zshenv
			echo "Unset boxName. Quitting."
		fi
	fi
fi
