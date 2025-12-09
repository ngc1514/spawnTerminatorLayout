# spawnTerminatorLayout
Scripted launcher for saved Terminator layouts that also creates a working directory for each box, useful for HackTheBox or similar tasks.

## Features
* Opens a saved Terminator layout with one command.
* Creates a fresh working directory per target.
* Accepts an optional IP to pass into your pane commands.

## Requirements
* Terminator installed:
  ```bash
  sudo apt update
  sudo apt install terminator
  ```
* A saved Terminator layout (default name expected: `htb`).

## Usage
```bash
./spawnTerminator.sh <box_name>
./spawnTerminator.sh <box_name> <box_ip>
```
* Creates `<box_name>` under `~/HTB/` by default.
* Launches Terminator with the saved layout and any commands tied to it.

## Configuration
`spawnTerminator.conf` lives next to the script and is created on first run. Edit this file—not the script—to set your defaults:

```bash
# Terminator layout name to launch
LAYOUT_NAME="htb"

# Base directory where box folders will be created
BASE_DIR="$HOME/HTB"
```

* `LAYOUT_NAME`: saved Terminator layout to launch.
* `BASE_DIR`: root folder for per-box directories; `~` is supported.

## Customization
- Change `LAYOUT_NAME` if you save a layout under a different name in Terminator.
- Point `BASE_DIR` at another workspace if you don't want `~/HTB` (e.g., `/opt/boxes`).
- Remove `spawnTerminator.conf` to regenerate it with defaults on the next run.

## Notes
* Ensure your Terminator layout name matches the script.
* Add commands per pane or tab in Terminator, save the layout, then run the script.
