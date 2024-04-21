#!/bin/bash

docker-compose -f ./docker-compose/docker-compose.yaml up -d
docker-compose logs -f > logs.txt
