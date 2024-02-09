#!/usr/bin/env bash

# Define log file
LOG_FILE="/var/log/sync_script.log"

# Function for logging
log() {
  local log_message="$1"
  echo "$(date +"%Y-%m-%d %T") - $log_message" >> "$LOG_FILE"
  echo "$log_message";
}

# Check if required arguments are provided
if [ $# -ne 3 ]; then
  log "Usage: $0 <origin_folder> <target_folder> <ssh_server>"
  exit 1
fi

ORIGIN_FOLDER="$1"
TARGET_FOLDER="$2"
SSH_SERVER="$3"

# Define the events to watch for
EVENTS="CREATE,DELETE,MODIFY,MOVED_FROM,MOVED_TO"

# Function to perform the synchronization
sync_files() {
  rsync --update -alvzr "$ORIGIN_FOLDER"/* "$SSH_SERVER":"$TARGET_FOLDER" >> "$LOG_FILE" 2>&1
  if [ $? -eq 0 ]; then
    log "Sync was successful"
  else
    log "Sync failed"
  fi
}

# Function to watch for file system events
watch_folder() {
  inotifywait -e "$EVENTS" -m -r --format '%:e %f' "$ORIGIN_FOLDER" >> "$LOG_FILE" 2>&1
}

# Continuously watch for events and sync files
while true ; do
  watch_folder | while read -t 1 LINE; do sync_files; done
done
