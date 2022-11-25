# kubernetes-examples

In enterprise environments, sometimes it can be a burden to get a clear picture of how certain things work. This repository comprises of code and configuration for barebone examples of real world problems one may encounter.

## Services
- `hello-world-client`: A service that runs forever as an HTTP client and makes requests to a server.
- `hello-world-server`: A server that sends a basic response to the client.
- `leaky-server`: A server that simulates a leaky program. Used for examination of the memory consumption in a container within a k8s environment.

## Scripts
- `start-istio-cluster.bash`: A simple bash script that does all the provisioning of infra and services of istio onto a minikube cluster.

## K8s-Config
- `services.yaml`: A yaml template of a k8s config that will have a couple values replaced at the time of application onto the kubernetes cluster.
- `leaky-server.yaml`: A yaml configuration that applies a deployment and a service for the leaky server.