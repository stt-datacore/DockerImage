#!/bin/bash
#FILE=/data/runcomplete
#if [ -f "$FILE" ]; then
#    echo "First run already performed"
#else
#    echo "Performing first run now"
#    cp -rn /dataorig/. /data/
#    cd /datacore-bot/src/DataCore.CLI/
#    echo "Training behold images"
#    dotnet run train
#    echo "Training complete"
#    cd /asset-server/
#    echo "First run complete, next time, please run with XXXXX at the end of your docker command"
#fi

##################################################
# Setting up static website content              #
##################################################

# Check if the attached data folder contains website data, if not create the folder
if [ ! -d /data/website ]
then
    echo "Website folder doesn't exist in your data folder, creating it."
    mkdir /data/website
fi

# If the /website symlink doesn't exist, create it.  Not sure it will ever exist...
if [ ! -d /website ]
then
    echo "Linking your website data folder into place"
    ln -s /data/website /website
fi

# If the git config isn't there, check the folder is empty, then clone the repo and build it
if [ ! -f /website/.git/config ]
then
    if [ ! "$(ls -A /website)" ]
    then
        echo "Cloning website repository"
        git clone https://github.com/stt-datacore/website.git /website
        echo "Linking env to website"
        ln -s /data/config/env /website/.env
        echo "Building website, this may take some time"
        /website/publish.sh -f
    else
        echo "'website' folder in your data area is not empty, and does not appear to contain the git repo for the website."
        echo "Please clean it up and start again"
        exit 1
    fi
fi

##################################################
# Start site server                              #
##################################################

echo "Starting site server"
if [ ! -f /site-server/.env ]
then
    ln -s /data/config/env /site-server/.env
fi

if [ ! -d /data/profiles ]
then
    echo "Creating a folder to store profiles in, as you don't seem to have one"
    mkdir /data/profiles
fi

if [ ! -d /site-server/static ]
then
    ln -s /data/profiles /site-server/static
fi

cd /site-server
pm2 --name server start npm -- start

##################################################
# Start discord bot                              #
##################################################

echo "Starting bot"
if [ ! -f /bot/.env ]
then
    ln -s /data/config/env /bot/.env
fi
cd /bot
pm2 --name bot start npm -- start

##################################################
# Run asset server updates                       #
##################################################

if [ ! -d /data/asset-server ]
then
    echo "Website folder doesn't exist in your data folder, creating it."
    mkdir /data/asset-server
fi

if [ ! -L /asset-server/out ]
then
    echo "Linking asset server in"
    mv /asset-server/out/* /data/asset-server
    rm -rf /asset-server/out
    ln -s /data/asset-server /asset-server/out
fi

if [ ! -L /asset-server/build/out ]
then
    echo "Linking asset server in"
    ln -s /data/asset-server /asset-server/build/out
fi

echo "Downloading assets. This will take a couple of hours on the first run"
/asset-server/exec.sh


##################################################
# Start remaining services and crontab           #
##################################################

echo "Copy crontab in"
crontab -i /data/config/crontab

echo "Starting nginx"
service nginx start

echo "Starting cron"
service cron start

##################################################
# Start image analysis server                    #
##################################################

if [ ! -d /data/train ]
then
    echo "Behold training data folder does not exist, creating it."
    mkdir /data/train
fi

echo "Starting image analysis server.  Training will take some time before analysis can take place"
cd /cpp-image-analysis/build
pm2 start "./imserver --jsonpath=/website/static/structured/ --trainpath=/data/train/ --datapath=/cpp-image-analysis/data/ --asseturl=https://assets.datacore.app/" --name "imageAnalysis"

pm2 logs
