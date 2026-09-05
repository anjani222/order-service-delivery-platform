# Order Service Delivery Platform

**Independent DevOps portfolio implementation**  
**Owner:** Anjani Kumar Jha  
**Target roles:** Senior DevOps Engineer, CloudOps Engineer, Platform Engineer

## Overview

Order Service Delivery Platform is an AWS-focused reference implementation for taking a small Java service from source control to a controlled Kubernetes release. The API is intentionally compact; the engineering focus is infrastructure automation, repeatable CI, secure container delivery, GitOps promotion, observability and rollback.

The project is suitable for public review because it recreates the delivery pattern without using employer source code, credentials or internal infrastructure information.

## Technology scope

- Java 21, Spring Boot, Maven and JUnit
- Git, GitHub Actions and Jenkins
- SonarQube and Trivy quality/security gates
- Docker and Amazon ECR immutable image tags
- Terraform-managed AWS VPC, EKS and ECR
- Kubernetes, Helm, Argo CD and Nginx Ingress
- Health probes, HPA, PDB, Prometheus and Grafana
- Bash automation, smoke testing, operations runbook and Git-based rollback

## Delivery workflow

1. A code change is pushed to the application repository.
2. Jenkins checks out the exact revision and runs Maven tests.
3. SonarQube is used as an optional quality gate.
4. Jenkins builds the container and Trivy checks it for critical vulnerabilities.
5. A commit-SHA-tagged image is pushed to Amazon ECR.
6. Jenkins updates the image tag in a separate GitOps repository.
7. Argo CD reconciles the Helm release on Kubernetes.
8. Probes, autoscaling, disruption protection and Prometheus metrics support operations.
9. A release can be rolled back by reverting the GitOps commit.

## Design choices

- Application source and desired deployment state are kept in separate repositories.
- Jenkins produces and promotes the artifact; Argo CD owns cluster reconciliation.
- Image tags are immutable and traceable to an application commit.
- The runtime container uses a non-root account and a read-only root filesystem in Kubernetes.
- The development VPC uses one NAT gateway to limit lab cost; a production design would evaluate one per Availability Zone.
- Cloud resources are reviewed with `terraform plan` before creation and destroyed after the demonstration window.

## Current position

The complete implementation and runbooks are packaged. Repository-level structural checks are complete. Local, CI and AWS execution evidence is being added milestone by milestone; no unverified production result or numerical improvement is claimed.

## Public repository plan

- `anjani222/order-service-delivery-platform`
- `anjani222/order-service-gitops`

The repository README contains local Docker, local Kubernetes, AWS provisioning, pipeline, rollback and troubleshooting instructions.

