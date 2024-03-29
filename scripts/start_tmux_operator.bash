#!/bin/bash

DAY=$(date "+%Y-%m-%d")
NOW=$(date "+%Y-%m-%dT%H.%M.%S.%N")
LOGDIR="/home/field/project11/logs"
mkdir -p "$LOGDIR"
LOG_FILE="${LOGDIR}/autostart_operator_core_${NOW}.txt"

{

printenv
set -x

echo ""
echo "#############################################"
echo "Starting operator core"
date
echo "#############################################"
echo ""

while ! ping -c 1 -W 1 robobox; do
	sleep 1
done

source /home/field/.bashrc

export ROS_MASTER_URI=http://robobox:11311
export ROS_IP=$ROBOBOX_ROS_IP

/usr/bin/tmux new -d -s project11
/usr/bin/tmux send-keys -t project11 "rosrun rosmon rosmon --name=rosmon_p11_operator_core drix_project11 operator_core.launch drixNumber:=8 logDirectory:=${LOGDIR}" C-m

set +x

} >> "${LOG_FILE}" 2>&1

