#!/usr/bin/env bash
set -euo pipefail

mvn -B -f app/pom.xml clean verify
docker build -t order-service:validation .
helm lint gitops-repository/charts/order-service -f gitops-repository/charts/order-service/values-dev.yaml
helm template orders-dev gitops-repository/charts/order-service -f gitops-repository/charts/order-service/values-dev.yaml >/tmp/order-service-rendered.yaml
terraform -chdir=infra/terraform fmt -check
terraform -chdir=infra/terraform init -backend=false
terraform -chdir=infra/terraform validate

echo "All application, container, Helm, and Terraform checks passed."
