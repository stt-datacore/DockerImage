#!/bin/bash
FILE=/data/runcomplete
if [ -f "$FILE" ]; then
    echo "First run already performed"
else
    echo "Performing first run now"
    cp -rn /dataorig/. /data/
    cd /datacore-bot/src/DataCore.CLI/
    echo "Training behold images"
    dotnet run train
    echo "Training complete"
    cd /asset-server/
    echo "First run complete, next time, please run with XXXXX at the end of your docker command"
fi
