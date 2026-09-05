#!/usr/bin/env bash
set -euo pipefail

command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }
command -v helm >/dev/null || { echo "helm is required"; exit 1; }

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace --wait --timeout 10m

helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system --wait --timeout 10m

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace --wait --timeout 15m

helm upgrade --install argocd argo/argo-cd \
  --namespace argocd --create-namespace --wait --timeout 15m

echo "Platform add-ons are ready. Update repository/image placeholders before applying gitops-repository/argocd/application.yaml."
