#!/bin/bash
echo "Status: 200"
echo "Content-type: application/json"
echo
LOG_TAIL=$(tail -n 1 /var/log/nginx/rstudio.access.log)
LAST_ACTIVITY=$(echo $LOG_TAIL | grep -Po 'last_activity":"\K.*?(?=")')
if [[ $(date -d $LAST_ACTIVITY"+10 minutes" +%s) -lt $(date +%s) ]]; then
    # No activity for the past 10mn, we consider VSCode idle and begin to send idle response
    sed s/busy/idle/ <<<"$LOG_TAIL"
else
    echo $LOG_TAIL
fi