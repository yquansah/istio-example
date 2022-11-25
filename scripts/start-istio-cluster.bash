#!/bin/bash
set -eu -o pipefail

# version the image that we are building with the short commit hash.
SHORT_HASH=$(git rev-parse --short HEAD)

main() {
    ensure_command docker
    ensure_command kubectl
    ensure_command minikube
    ensure_command istioctl

    install_cluster
    install_istio_onto_cluster
    build_docker_images
    deploy_services
}

ensure_command() {
    type -P "${1}" &> /dev/null || { echo Command \""${1}"\" not found; exit 1; }
}

install_cluster() {
    echo "Starting local kubernetes cluster with minikube..."
    # starting kubernetes cluster.
    minikube start --memory=8150 --cpus=4
}

install_istio_onto_cluster() {
    # precheck for istio installation on the cluster.
    echo "Running precheck command to see istio compatibility on minikube cluster..."
    istioctl experimental precheck
    
    echo "Going ahead with the istio installation now..."

    # acutal install command of istio.
    istioctl install --set profile=demo -y

    # we want to check for istio related deployments to be ready before we proceed with anything else.
    while [ $(kubectl get deployments -n istio-system | grep 'istio' | wc -l) -lt 3 ]
        do
            echo "Waiting for the istio related deployments to be ready..."
        done
    
    echo "You are now ready to use istio in local cluster!"

    echo "Enabling sidecar injection in cluster..."

    kubectl label namespace default istio-injection=enabled --overwrite

    echo "Sidecar injection enabled!"
}

build_docker_images() {
    docker build ./services/hello-world-client -t hello-world-client:$SHORT_HASH

    docker build ./services/hello-world-server -t hello-world-server:$SHORT_HASH
}

deploy_services() {
    if [ $(docker images | grep $SHORT_HASH | wc -l) -ne 2 ]
    then
        echo "The docker images do not exist to deploy..."
        exit 1
    fi

    CLIENT_IMAGE=hello-world-client:$SHORT_HASH
    SERVER_IMAGE=hello-world-server:$SHORT_HASH

    echo "Loading server image into minikube cluster..."
    minikube image load $SERVER_IMAGE
    echo "Server image successfully loaded into minikube cluster!"

    echo "Loading client image into minikube cluster..."
    minikube image load $CLIENT_IMAGE
    echo "Client image successfully loaded into minikube cluster!"

    cat ./k8s-config/services.yaml | sed "s/CLIENT_IMAGE/$CLIENT_IMAGE/g" | sed "s/SERVER_IMAGE/$SERVER_IMAGE/g" | kubectl apply -f -
}

main "$@"