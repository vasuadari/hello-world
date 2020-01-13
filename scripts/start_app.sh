#! /bin/bash

export PORT=4000
export RACK_ENV=$RACK_ENV

APP_NAME="hello-world"
CONTAINER_NAME=${APP_NAME}_app_
# lets find the first container
FIRST_NUM=`docker ps | awk '{print $NF}' | grep $CONTAINER_NAME | awk -F  "_" '{print $NF}' | sort | head -1`
DOCKER_COMPOSE_PATH=${DOCKER_COMPOSE_PATH:-/home/ubuntu/opt/$APP_NAME/docker-compose.yml}

if [[ "$FIRST_NUM" != "" ]]; then
  NUM_OF_CONTAINERS=1
  MAX_NUM_OF_CONTAINERS=2

  docker-compose -f $DOCKER_COMPOSE_PATH scale app=$MAX_NUM_OF_CONTAINERS
  NEW_CONTAINER_NAME=${CONTAINER_NAME}$(expr $FIRST_NUM + 1)

  # waiting for new containers
  until docker ps --filter "Name=$NEW_CONTAINER_NAME"|grep '(healthy)'
  do
    echo "Waiting for container - $NEW_CONTAINER_NAME to be healthy"
    sleep 5
  done

  # removing old containers
  for ((i=$FIRST_NUM;i<$NUM_OF_CONTAINERS+$FIRST_NUM;i++))
  do
     docker stop $CONTAINER_NAME$i
     docker rm $CONTAINER_NAME$i
  done

  docker-compose -f $DOCKER_COMPOSE_PATH scale app=$NUM_OF_CONTAINERS
else
  docker-compose -f $DOCKER_COMPOSE_PATH up -d
fi
