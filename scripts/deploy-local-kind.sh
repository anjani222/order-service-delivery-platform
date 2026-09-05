#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-devops-demo}"
IMAGE="order-service:local"

command -v kind >/dev/null || { echo "kind is required"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }
command -v helm >/dev/null || { echo "helm is required"; exit 1; }

kind get clusters | grep -qx "${CLUSTER_NAME}" || kind create cluster --name "${CLUSTER_NAME}"
docker build -t "${IMAGE}" .
kind load docker-image "${IMAGE}" --name "${CLUSTER_NAME}"

helm upgrade --install orders-dev gitops-repository/charts/order-service \
  --namespace orders-dev --create-namespace \
  --set image.repository=order-service \
  --set image.tag=local \
  --set image.pullPolicy=Never \
  --set ingress.enabled=false \
  --set autoscaling.enabled=false

kubectl rollout status deployment/orders-dev-order-service -n orders-dev --timeout=180s
kubectl port-forward -n orders-dev service/orders-dev-order-service 8080:80
