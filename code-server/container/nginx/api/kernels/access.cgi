#!/bin/bash
echo "Status: 200"
echo "Content-type: application/json"
echo
LOG_TAIL=$(tail -n 1 /var/log/nginx/vscode.access.log)
LAST_ACTIVITY=$(echo $LOG_TAIL | grep -Po 'last_activity":"\K.*?(?=")')
if [[ $(date -d $LAST_ACTIVITY"+10 minutes" +%s) -lt $(date +%s) ]]; then
    # No activity for the past 10mn, we consider VSCode idle
    # and echo an idle answer with this last_activity time + 10mn.
    # So in practice culling will happen 10mn after culling setting.
    # If you have a better solution you're welcome!
    echo '[{"id":"code-server","name":"code-server","last_activity":"'$(date -d $LAST_ACTIVITY"+10 minutes" -Iseconds)'","execution_state":"idle","connections":1}]'
else
    echo $LOG_TAIL
fi