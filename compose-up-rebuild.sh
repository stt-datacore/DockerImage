#!/bin/bash
cd multidocker
sudo docker compose --profile tower-stack build --no-cache
sudo docker compose --profile tower-stack up --build -d
sudo docker compose --profile tower-stack exec tower-stack docker-compose -f /docker/docker-compose.yml --profile fullstack down
sudo docker compose --profile tower-stack exec tower-stack docker-compose -f /docker/docker-compose.yml --profile fullstack build --no-cache
sudo docker compose --profile tower-stack exec tower-stack docker-compose -f /docker/docker-compose.yml --profile fullstack up $1

