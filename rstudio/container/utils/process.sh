#!/usr/bin/env bash

function start_process() {
    trap stop_process TERM INT

    echo "Running command: $@"
    "$@" &

    PID=$!
    wait $PID
    trap - TERM INT
    wait $PID
    STATUS=$?
    exit $STATUS
}

function stop_process() {
    echo "Stopping rstudio-server"
    rstudio-server suspend-all
    sleep 5 #Wait for the session to properly stop
    kill -TERM $PID
}
