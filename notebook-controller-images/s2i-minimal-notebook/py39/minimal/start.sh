#!/bin/bash

set -x

if [ $# -eq 0 ]; then
    echo "Executing the command: bash"
    exec bash
else
    echo "Executing the command: $@"
    exec "$@"
fi
