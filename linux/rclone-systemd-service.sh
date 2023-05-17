#!/bin/bash
rclone --vfs-cache-mode writes mount OneDrivePersonal: ~/Mount/OneDrive_Personal/ &
rclone --vfs-cache-mode writes mount OneDriveBusiness: ~/Mount/OneDrive_Business/ &
rclone --vfs-cache-mode writes mount Memories: ~/Mount/Memories/ &

[Unit]
Description=OneDrive Personal Sync Service
AssertPathIsDirectory=~/Mount/OneDrive_Personal
After=plexdrive.service 

[Service]
Type=simple
ExecStart=/usr/bin/rclone \
        --vfs-cache-mode \
        writes \
        mount \
        OneDrivePersonal:/ ~/Mount/OneDrive_Personal
ExecStop=/bin/fusermount -u ~/Mount/OneDrive_Personal
Restart=always
Restart=10

[Install]
WantedBy=default.target


[Unit]
Description=Google Drive (rclone)
Requires=systemd-networkd.service
AssertPathIsDirectory=/media/gdrive
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount \
        --config=/home/adam/.config/rclone/rclone.conf \
        --allow-other \
        --fast-access \
        --cache-tmp-upload-path=/tmp/rclone/upload \
        --cache-chunk-path=/tmp/rclone/chunks \
        --cache-workers=4 \
        --cache-writes \
        --cache-dir=/tmp/rclone/vfs \
        --cache-db-path=/tmp/rclone/db \
        --no-modtime \
        --drive-use-trash \
        --stats=0 \
        --checkers=8 \
        --dir-cache-time=60m \
        --allow-non-empty \
        --cache-info-age=60m gdrive:/ /media/gdrive
ExecStop=/bin/fusermount -u /media/gdrive
Restart=always
RestartSec=10
TimeoutSec=45

[Install]
WantedBy=multi-user.target