#!/bin/bash
set -e

echo "Initializing"

#===== CUSTOMIZE =====
# Mount network shared drive
MOUNT_FOLDER="Public"
MOUNT_HOST="192.168.1.13"
MOUNT_SOURCE="//$MOUNT_HOST/$MOUNT_FOLDER"
MOUNT_DEST="/data/mount"
mkdir -p "$MOUNT_DEST"
echo "Mounting $MOUNT_SOURCE to $MOUNT_DEST"
mount -t cifs -o username=root,password=,guest,uid=1000,gid=1000,rw,file_mode=0777,dir_mode=0777,sfu "$MOUNT_SOURCE" "$MOUNT_DEST"
if [ $? -eq 0 ]; then
    echo "Mounted successfully."
else
    echo "Mounting failed!"
fi
#===== CUSTOMIZE =====

# Configure transmission
: ${DOWNLOADS_DIR:="/data/Downloads"}
: ${DELUGE_CONFIG_DIR:="/data/deluge"}
: ${DELUGE_LOGLEVEL:="info"}
DELUGE_SETTINGS_PATH="$DELUGE_CONFIG_DIR/core.conf"
DELUGE_LOGS_PATH="$DELUGE_CONFIG_DIR/deluged.log"

# Setup Deluge
mkdir -p "$DOWNLOADS_DIR"
if [ -d "$DELUGE_CONFIG_DIR" ]; then
    # Exists
    echo "Deluge already configured at \"$DELUGE_CONFIG_DIR\"."
else
    # Does not exist
    echo "Deluge is not configured at \"$DELUGE_CONFIG_DIR\"."
    mkdir -p "$DELUGE_CONFIG_DIR"
    cp core.conf "$DELUGE_SETTINGS_PATH"
    echo "Created Deluge configuration at $DELUGE_SETTINGS_PATH"
fi

echo "Clean up old Deluge"
rm -f "$DELUGE_CONFIG_DIR/deluged.pid"

echo "Start Deluge daemon"
deluged --config=$DELUGE_CONFIG_DIR --loglevel=$DELUGE_LOGLEVEL --logfile=$DELUGE_LOGS_PATH
echo "Start Deluge-Web daemon"
deluge-web --config=$DELUGE_CONFIG_DIR --loglevel=$DELUGE_LOGLEVEL --port=80
