#!/bin/bash

# BSD/macOS sed requires an empty string after -i; GNU sed accepts it too.
SED_INPLACE=("-i" "")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/spawnTerminator.conf"
DEFAULT_LAYOUT_NAME="htb"
DEFAULT_BASE_DIR="$HOME/HTB"

# Create a config file with defaults if none exists, then load it.
function loadConfig() {
	if [ ! -f "$CONFIG_FILE" ]; then
		cat > "$CONFIG_FILE" <<'EOF'
# Terminator layout name to launch
LAYOUT_NAME="htb"

# Base directory where box folders will be created
BASE_DIR="$HOME/HTB"
EOF
		echo "Created default config at $CONFIG_FILE. Update LAYOUT_NAME and BASE_DIR as needed."
	fi

	# shellcheck source=/dev/null
	source "$CONFIG_FILE"

	layoutName="${LAYOUT_NAME:-$DEFAULT_LAYOUT_NAME}"
	baseDir="${BASE_DIR:-$DEFAULT_BASE_DIR}"

	# Expand ~/ in BASE_DIR if used
	baseDir="${baseDir/#\~/$HOME}"

	if [ -z "$layoutName" ] || [ -z "$baseDir" ]; then
		echo "LAYOUT_NAME and BASE_DIR must be set in $CONFIG_FILE"
		exit 1
	fi
}

# init env var
if ! grep -Fq "boxName=" ~/.zshenv
then
	echo "Initializing environment variable \"boxName\""
	echo "boxName=" >> ~/.zshenv
	source ~/.zshenv
fi

if ! grep -Fq "boxIP=" ~/.zshenv
then
	echo "Initializing environment variable \"boxIP\""
	echo "boxIP=" >> ~/.zshenv
	source ~/.zshenv
fi


boxNameArg=$1
boxIPArg=$2

loadConfig

function spawning() {
	boxDir="$baseDir/$boxName"
	echo "spawning: $boxDir"

	# Directory exists, CD to that dir
	if [ -d "$boxDir" ]; then
		echo "Directory ${boxDir} already exists. Changing directory."
	else
		echo "Creating directory $boxDir"
		mkdir -p "$boxDir"
	fi
	echo "Spawning layout ${layoutName} for \"$boxName\"..."
	terminator -l "$layoutName"
}

function quitAndReset(){
	sed "${SED_INPLACE[@]}" "s/boxName=.*/boxName=/g" ~/.zshenv
	sed "${SED_INPLACE[@]}" "s/boxIP=.*/boxIP=/g" ~/.zshenv
	source ~/.zshenv
	echo "Unsetting info. Quitting..."
	exit 0;
}


# Usage message
if [[ "$#" = 0 ]] || [[ "$#" > 2 ]]; then
	echo -e "Example 1: ./spawnTerminator.sh yourBoxName 
	\nExample 2: ./spawnTerminator.sh yourBoxName 
	\nExample 3: ./spawnTerminator.sh yourBoxName yourBoxIP
	\nQuitting."


# Confirm and call spawning()  
elif [[ "$#" -ge 1 ]] || [[ "$#" -le 2 ]]; then
	# set env var boxName in .zshenv and source the file
	sed "${SED_INPLACE[@]}" "s/boxName=.*/boxName=$boxNameArg/g" ~/.zshenv
	source ~/.zshenv
	echo "New boxName: $boxName"
	message1="Confirm box name \"$boxName\"? [y/N]"

	# if IP is entered, store IP to env var
	if [[ "$#" = 2 ]]; then
		if [[ $boxIPArg =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
			sed "${SED_INPLACE[@]}" "s/boxIP=.*/boxIP=$boxIPArg/g" ~/.zshenv
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
