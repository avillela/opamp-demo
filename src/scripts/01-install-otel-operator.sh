#! /bin/bash

## Installs cert-manager and the OTel Operator
## Note that the OTel Operator needs cert-manager to be installed first.

## Install cert-manager and wait for its webhook to be ready.
echo "*********** Deploying Cert Manager (required for OpenTelemetry Operator) ***********"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.21.1/cert-manager.yaml
echo "Waiting for cert-manager to start (up to 5 minutes)..."
kubectl wait --for=condition=Available deployment --all -n cert-manager --timeout=300s
echo "Waiting for the cert-manager webhook's CA to be issued..."
kubectl wait --for=jsonpath='{.webhooks[0].clientConfig.caBundle}' validatingwebhookconfiguration/cert-manager-webhook --timeout=300s


## Grant the operator permission to manage collector RBAC. Apply this before the operator itself, so the operator picks the grant up on its first start.
echo "*********** Deploying the OpenTelemetry Operator ***********"
kubectl apply -f src/k8s/operator-rbac.yaml

## Install the OTel Operator and wait for its webhook to be ready.
echo "*********** Deploying the OpenTelemetry Operator ***********"
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.156.0/opentelemetry-operator.yaml
echo "Waiting for the operator to start (up to 5 minutes)..."
kubectl wait --for=condition=Available deployment/opentelemetry-operator-controller-manager -n opentelemetry-operator-system --timeout=300s
echo "Waiting for the operator webhook's CA to be issued..."
kubectl wait --for=jsonpath='{.webhooks[0].clientConfig.caBundle}' validatingwebhookconfiguration/opentelemetry-operator-validating-webhook-configuration --timeout=300s
