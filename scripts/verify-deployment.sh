#!/bin/bash
# scripts/verify-deployment.sh
NAMESPACE=$1
echo "Verifying Zabbix deployment in namespace: $NAMESPACE"

kubectl rollout status deployment -n $NAMESPACE --timeout=5m

PODS=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=zabbix \
  --field-selector=status.phase=Running --no-headers | wc -l)

if [ "$PODS" -lt 1 ]; then
  echo "❌ No running Zabbix pods found!"
  kubectl get pods -n $NAMESPACE
  exit 1
fi

echo "✅ $PODS Zabbix pod(s) running successfully"