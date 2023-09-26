#!/bin/bash
cd multidocker
echo Compose Script - Full Datacore Stack
echo     Note: add -d if you wish to start detached
sudo docker compose --profile tower-stack up --build $1