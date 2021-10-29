#!/bin/bash

#called from cron @reboot using field users cron

DAY=$(date "+%Y-%m-%d")
NOW=$(date "+%Y-%m-%dT%H.%M.%S.%N")
LOGDIR="/home/field/project11/log/${DAY}"
mkdir -p "$LOGDIR"
LOG_FILE="${LOGDIR}/autostart_${NOW}.txt"

while ! ping -c 1 -W 1 mdt; do
	sleep 1
done

sleep 10

source /opt/ros/noetic/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

export ROS_MASTER_URI=http://mdt:11311
export ROS_IP=192.168.8.180

#open a new tmux session and launch the km_convert script
#this is used to split the km_binary from the phins 

/usr/bin/tmux new -d -s km_convert
/usr/bin/tmux send-keys -t km_convert "cd ~/km_convert/" C-m
/usr/bin/tmux send-keys -t km_convert "./km_convert.py" C-m

#open a new tmux session, source the ros master, and run the drix.launch file to startup the backset project 11

/usr/bin/tmux new -d -s project11
/usr/bin/tmux send-keys -t project11 "rosrun rosmon rosmon --name=rosmon_project11 drix_project11 drix.launch drixNumber:=8 operator_ip:=192.168.8.182 logDirectory:=${LOGDIR}" C-m