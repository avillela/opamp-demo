#! /bin/bash

kubectl create namespace opamp
kubectl -n opamp create secret generic opamp-server \
  --from-literal=SECRET_KEY_BASE="$(openssl rand -base64 48)" \
  --from-literal=PGPASSWORD="$(openssl rand -hex 16)"

kubectl apply -k src/k8s
kubectl -n opamp rollout status statefulset/opamp-postgres
kubectl -n opamp rollout status deployment/opamp-server