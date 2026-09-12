# Project Evidence

This directory contains sanitized evidence collected during the hands-on implementation of the Professional GitOps Delivery Platform.

## Verified environment

- Amazon EKS cluster: `gitops-platform-dev`
- Application namespace: `orders-dev`
- Monitoring namespace: `monitoring`
- CI/CD pipeline: GitHub webhook and Jenkins
- GitOps deployment: Argo CD and Helm
- Container registry: Amazon ECR
- Monitoring: Prometheus and Grafana
- Final verified image: `805a78f7`
- Final application state: three ready pods with zero restarts
- Argo CD state: `Synced` and `Healthy`

## Evidence catalogue

| File | Evidence |
| --- | --- |
| `01-github-repository.jpg` | Main source repository structure and latest commits |
| `02-github-webhook-success.jpg` | Successful GitHub ping and push webhook deliveries |
| `03-jenkins-build-10-success.jpg` | Successful automatically triggered Jenkins Build #10 |
| `04-jenkins-pipeline-stages.jpg` | Maven, SonarQube, Docker, Trivy, ECR and GitOps pipeline stages |
| `05-sonarqube-quality-gate.jpg` | Successful SonarQube Quality Gate |
| `06-trivy-zero-critical.jpg` | Container scan reporting zero critical vulnerabilities |
| `07-ecr-immutable-image.jpg` | Commit-based immutable image stored in Amazon ECR |
| `08-argocd-synced-healthy.png` | Argo CD application in Synced and Healthy state |
| `09-eks-pods-ready.png` | Three ready EKS application pods with zero restarts |
| `10-prometheus-targets-up.png` | Prometheus scraping all three order-service targets with value 1 |
| `11-grafana-orders-dashboard.png` | Live CPU and memory metrics for the orders-dev namespace |
| `12-gitops-rollback-history.png` | Controlled rollback and restoration commits |

## Rollback verification

The deployment was rolled back from image `4c5a6dd1` to previously verified image `a4c5a8a5` through GitOps commit `9001c83`.

Argo CD synchronized the rollback, Kubernetes completed the rolling update, and all three application pods became ready with zero restarts.

The latest image was restored through GitOps commit `592e338`. The final Jenkins execution subsequently deployed image `805a78f7`.

## Security note

All screenshots must be reviewed before publication. Passwords, tokens, private keys, session details and credentials must never be included. AWS account identifiers, public IP addresses and personal information should be cropped or masked where they are not necessary to demonstrate the project.