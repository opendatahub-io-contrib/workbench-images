#!/bin/bash
echo "Status: 200"
echo "Content-type: application/json"
echo
# Query the heartbeat endpoint
HEALTHZ=$(curl -s http://127.0.0.1:8888/vscode/healthz)
# Extract last_activity | remove milliseconds
LAST_ACTIVITY_EPOCH=$(echo $HEALTHZ | grep -Po 'lastHeartbeat":\K.*?(?=})' | awk '{ print substr( $0, 1, length($0)-3 ) }')
# Convert to ISO8601 date format
LAST_ACTIVITY=$(date -d @$LAST_ACTIVITY_EPOCH -Iseconds)
# Extract status and replace with terms expected by culler
STATUS=$(sed 's/alive/busy/;s/expired/idle/' <<< $(echo $HEALTHZ | grep -Po 'status":"\K.*?(?=")'))
# Export in format expected by the culling engine
echo '[{"id":"code-server","name":"code-server","last_activity":"'$LAST_ACTIVITY'","execution_state":"'$STATUS'","connections":1}]'
