# spawnTerminatorLayout
Tired of splitting Terminator's terminals every time and typing all the commands manually? Spawn your saved layout and new directories for pentesting or HackTheBox with this one simple trick! (Aight I'll stop). You can preset multiple tabs and custom commands for Terminator then use this script to spawn all of them automatically. 


### Pre-req
1) Terminator is installed. If not: <br>
```
$ sudo apt update
$ sudo apt install terminator
```
<br>


2) **Have a layout already created.** If not, create a Terminator layout called "htb". <br>
For custom layout names, see: [Modifying the script](#modifying-the-script)
<br>


3) Creat a .zshenv file at current user's home directory (~/). If you are using ZSH, you can skip this step.

```
# create a .zshenv file at home if you don't have one
$ touch ~/.zshenv
```
<br>


### Run script to create corresponding box directory and spawn your layout
Examples: 
```
./spawnHTB.sh <some_box_name> 
./spawnHTB.sh <some_box_name> <box_ip>
```
<br>


### Modifying the script
Ln 36
```
terminator -l htb
```
Change "htb" to the name of your layout. <br>
<br>


Ln 24
```
boxDir="$HOME/HTB/$boxName"
```
Change it to your own path.
<br>
