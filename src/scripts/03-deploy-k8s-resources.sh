#! /bin/bash

kubectl apply -f src/k8s/namespace.yaml
kubectl apply -f src/k8s/opamp-bridge-rbac.yaml
kubectl apply -f src/k8s/opamp-bridge.yaml
kubectl apply -f src/k8s/otel-collector-rbac.yaml
kubectl apply -f src/k8s/otel-collector.yaml