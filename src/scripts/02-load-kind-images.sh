#! /bin/bash

# Load image into KinD using docker command because somehow `kind load` caused things to crap out
docker exec otel-opamp-demo-control-plane crictl pull ghcr.io/avillela/opamp-server:20260930
# kind load docker-image ghcr.io/avillela/opamp-server:20260930 -n otel-opamp-demo