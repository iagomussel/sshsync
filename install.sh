#!/bin/bash

# Define the synchronization script and its destination
SYNC_SCRIPT="sshsync.sh"
SCRIPT_DESTINATION="/usr/local/bin/sshsync"

# get script from github
curl -o $SYNC_SCRIPT https://raw.githubusercontent.com/iagomussel/sshsync/main/sshsync.sh


# Define the log file and its destination
LOG_FILE="/var/log/sync_script.log"

chmod 777 $LOG_FILE

# Function for logging
log() {
  local log_message="$1"
  echo "$(date +"%Y-%m-%d %T") - $log_message" >> "$LOG_FILE"
  echo "$log_message";
}

install_sync_script() {
  if [ ! -f "$SCRIPT_DESTINATION" ]; then
    cp "$SYNC_SCRIPT" "$SCRIPT_DESTINATION"
    chmod +x "$SCRIPT_DESTINATION"
    log "Installed $SYNC_SCRIPT to $SCRIPT_DESTINATION"
  else
    log "Error: $SYNC_SCRIPT already exists at $SCRIPT_DESTINATION."
    exit 1
  fi
}

install_dependencies() {
  local dependencies=("inotify-tools" "rsync" "openssh-client")
  for dependency in "${dependencies[@]}"; do
    if ! dpkg-query -W -f='${Status}' "$dependency" 2>/dev/null | grep -q "ok installed"; then
      if [[ $EUID -ne 0 ]]; then
        echo "Error: This script must be run as root to install dependencies." >&2
        exit 1
      fi
      apt update >> "$LOG_FILE" 2>&1
      apt install -y "$dependency" >> "$LOG_FILE" 2>&1
      if [ $? -ne 0 ]; then
        echo "Error: Failed to install $dependency." >&2
        exit 1
      fi
      echo "Installed $dependency"
      log "Installed $dependency"
    fi
  done
}
# Check and install dependencies
install_dependencies

install_sync_script

chmod +x $SCRIPT_DESTINATION

echo "Sync script installed successfully"