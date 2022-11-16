# istio-example

In enterprise environments, sometimes it can be a burden to get a clear picture of how istio works, so in this repository we deploy some basic services with a light minikube set up to get a minimal picture of how [istio](https://istio.io/) works.

## Services
- `hello-world-client`: A service that runs forever as an HTTP client and makes requests to a server.
- `hello-world-server`: A server that sends a basic response to the client.

## Scripts
- `start-cluster.bash`: A simple bash script that does all the provisioning of infra and services onto a minikube cluster.

## K8s-Config
- `services.yaml`: A yaml template of a k8s config that will have a couple values replaced at the time of application onto the kubernetes cluster.