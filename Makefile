deploy-service:
	/bin/bash ./scripts/deploy-service.bash $(PARAM)

start-cluster:
	/bin/bash ./scripts/start-istio-cluster.bash

.PHONY: start-cluster, deploy-service