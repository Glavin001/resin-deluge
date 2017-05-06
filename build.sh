#!/bin/bash

echo "Generate Dockerfile"
dockerfile-template --define RESIN_MACHINE_NAME=raspberrypi > Dockerfile

echo "Build Docker image"
docker-compose build

echo "Create Docker container"
docker-compose up
