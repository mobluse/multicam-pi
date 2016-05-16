#!/bin/sh
SCRIPT_PATH=$(dirname $(realpath -s $0))
sudo crontab $SCRIPT_PATH/cron.txt
sudo crontab -l
