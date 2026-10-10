#! /bin/bash

# kubectl apply -f src/k8s/namespace.yaml
# kubectl apply -f src/k8s/opamp-server.yaml
kubectl apply -f src/k8s/elixir-bridge-rbac.yaml
kubectl apply -f src/k8s/elixir-bridge.yaml
# kubectl apply -f src/k8s/otel-collector-rbac.yaml
# kubectl apply -f src/k8s/otel-collector.yaml