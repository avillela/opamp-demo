#! /bin/bash

ENVFILE=$1

# Load environment variables from .env file
if [[ -n "${ENVFILE}" && -f ${ENVFILE} ]]; then
  echo "*** Loading environment variables from .env..."
  export $(grep -v '^#' ${ENVFILE} | xargs)
  echo "Environment variables loaded."
else
  echo "*** No ENV ${ENVFILE} file found in the current directory. Exiting."
  exit 1
fi

kubectl create ns bindplane

# The bridge reads its agent secret key from this Secret (referenced by env in OpAMPBridge).
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: bindplane-secrets
  namespace: "bindplane"
type: Opaque
stringData:
  secret-key: $BINDPLANE_SECRET
EOF

kubectl apply -f src/k8s/bindplane-bridge.yaml
