#!/bin/bash
set -eu -o pipefail

SHORT_HASH=$(git rev-parse --short HEAD)

main() {
    ensure_command docker
    ensure_command kubectl
    deploy_service $1
}

ensure_command() {
    type -P "${1}" &> /dev/null || { echo Command \""${1}"\" not found; exit 1; }
}

deploy_service() {
    echo "Building docker image for $1..."
    docker build ./services/$1 -t $1:$SHORT_HASH

    DOCKER_IMAGE=$1:$SHORT_HASH

    echo "Loading image into minikube for use..."
    minikube image load $DOCKER_IMAGE

    
}

main "$1"
