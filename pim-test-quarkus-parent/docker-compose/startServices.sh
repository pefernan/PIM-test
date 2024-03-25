#!/bin/sh

PROFILE="v1"

echo "Script requires your Kogito Example to be compiled"

PROJECT_VERSION=$(cd ../ && mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "Project version: ${PROJECT_VERSION}"
KOGITO_VERSION="latest"

if [ -n "$1" ]; then
  if [[ ("$1" == "v1") || ("$1" == "v2") || ("$1" == "infra")]];
  then
    PROFILE="$1"
  else
    echo "Unknown docker profile '$1'. The supported profiles are v1 / v2 / infra"
    exit 1;
  fi
fi

echo "Kogito Image version: ${KOGITO_VERSION}"
echo "KOGITO_VERSION=${KOGITO_VERSION}" > ".env"
echo "COMPOSE_PROFILES='${PROFILE}'" >> ".env"

if [ "$(uname)" == "Darwin" ]; then
   echo "DOCKER_GATEWAY_HOST=kubernetes.docker.internal" >> ".env"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   echo "DOCKER_GATEWAY_HOST=172.17.0.1" >> ".env"
fi

docker compose up