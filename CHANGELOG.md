# Changelog

## 1.0.2

- Removed competing Argo Image Updater annotations; Jenkins is now the single owner of Git image promotion.
- Split application CI and deployment state into separate repository layouts to prevent commit-trigger loops.
- Corrected ECR registry login and made SonarQube quality-gate execution explicit.
- Prevented Argo CD self-heal from conflicting with HPA-managed replica counts.
- Updated the Terraform AWS provider and VPC/EKS modules to the reviewed 2026 baseline.
- Replaced DynamoDB state locking with the S3 lockfile mechanism.
- Added restricted EKS API CIDR configuration, platform bootstrap and dependency update checks.

## 1.0.1

- Added repeatable Makefile targets and an HTTP smoke test.
- Documented design trade-offs and current verification status.
- Clarified the boundary between CI artifact creation and Argo CD deployment.
- Added explicit notes for placeholders, AWS cost and production gaps.

## 1.0.0

- Added Spring Boot order API, unit tests and health/Prometheus endpoints.
- Added secure container build, Jenkins pipeline and pull-request validation.
- Added Terraform VPC/EKS/ECR baseline and Helm/Argo CD deployment definitions.
- Added local Docker/kind workflows and an incident runbook.
