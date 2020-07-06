#!/bin/bash
FILE=/data/runcomplete
if [ -f "$FILE" ]; then
    echo "First run already performed"
else
    echo "Performing first run now"
    cp -r /dataorig/. /data/
fi
