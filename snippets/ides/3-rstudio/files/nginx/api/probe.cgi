#!/bin/bash
if [[ $(ps -aux | grep server | grep rsession) ]]; then
    echo "Status: 200"
    echo "Content-type: text/html"
    echo
    echo  "<html><body>RServer is up!</body></html>"
else
    echo "Status: 404"
    echo "Content-type: text/html"
    echo ""
    echo "<html><body>RServer is not running!</body></html>"
fi