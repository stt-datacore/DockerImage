#!/bin/bash
cd multidocker
sudo docker compose --profile tower-stack exec tower-stack docker-compose -f /docker/docker-compose.yml --profile fullstack down
sudo docker compose --profile tower-stack down

