#!/bin/sh

echo "Script requires your Kogito Example to be compiled"

PROJECT_VERSION=$(cd ../ && mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "Project version: ${PROJECT_VERSION}"
KOGITO_VERSION="latest"

echo "Kogito Image version: ${KOGITO_VERSION}"
echo "KOGITO_VERSION=${KOGITO_VERSION}" > ".env"

if [ "$(uname)" == "Darwin" ]; then
   echo "DOCKER_GATEWAY_HOST=kubernetes.docker.internal" >> ".env"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   echo "DOCKER_GATEWAY_HOST=172.17.0.1" >> ".env"
fi

docker compose up