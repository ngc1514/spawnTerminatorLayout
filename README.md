# spawnTerminatorLayout
Spawn your Terminator layout for HackTheBox/OSCP/pentesting

## Pre-req
1) Terminator is installed. If not <br>
```
$ sudo apt update
$ sudo apt install terminator
```
<br>

2) **Have a layout already created.** If not, create a Terminator layout your called "htb". <br>
For custom names, see: [Modifying the script](#modifying-the-script)
<br>

3) Set up key for a new environment variable called "boxName" in your zshenv file.

```
# create a .zshenv file at home if not have one
$ touch ~/.zshenv

# append the below key to the file
$ echo -en "\nexport boxName=\n" >> ~/.zshenv

# source the file
$ source ~/.zshenv
```
<br>

4) Make script executable
```
$ chmod +x spawnHTB.sh
```
<br>


## Run script to create corresponding directory and spawn new layout
Examples: 
```
./spawnHTB.sh <some_box_name> 
OR
./spawnHTB.sh <some_box_name> -y
```
<br>

## Modifying the script
Ln 17
```
terminator -l htb
```
Change "htb" to the name of your layout. <br>
<br>

Ln 7, 12, 13
```
DIR="~/HTB/$boxName"
echo "Creating directory ~/HTB/$boxName"
mkdir ~/HTB/$boxName
```
Change it to your own path.

