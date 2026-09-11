# Implementation status

This repository is an independent portfolio implementation. It is designed to reproduce a delivery pattern that can be demonstrated without publishing employer code, credentials or infrastructure details.

## Verified in the packaged baseline

- Project structure and internal documentation links
- Maven project XML structure
- Kubernetes and GitHub Actions YAML syntax
- Shell script syntax
- Separation between the application and GitOps repositories
- Immutable image-tag promotion design
- Terraform, Helm, security and rollback controls represented in code

## Hands-on verification completed

- Ran the Maven build with Java 21; two unit tests passed with no failures or errors, and the executable `order-service-1.0.0.jar` was generated.
- Started the JAR locally and verified the Actuator health endpoint and the GET/POST order endpoints.
- Built `order-service:1.0.0` using the multi-stage Dockerfile and verified the container reached healthy status.
- Published the project to GitHub and completed GitHub Actions validation for Maven tests, container build, Helm chart rendering and Terraform validation (run `33982307334`).
- Created a local Kubernetes v1.37.0 cluster using kind and loaded the application image into the cluster node.
- Installed the Helm release `orders-dev` in the `orders-dev` namespace and verified two ready application pods with zero restarts.
- Verified the health and order endpoints through the Kubernetes ClusterIP service using port forwarding.
- Tested manual scaling from two to three replicas, completed a rolling restart, and restored the Helm-managed replica count to two.
- Resolved a Helm 4 server-side apply conflict caused by the earlier `kubectl scale` operation and returned the release to deployed status at revision 3.

- Created the separate public GitOps repository `anjani222/order-service-gitops` containing the Helm chart and Argo CD Application manifest.
- Validated the GitOps repository through GitHub Actions; Helm linting and manifest rendering passed successfully (run `34040361525`).
- Installed Argo CD in the local kind cluster and verified all seven Argo CD pods were ready with zero restarts.
- Transferred deployment ownership from the manually installed Helm release to Argo CD and verified the application reached `Synced` and `Healthy` status.
- Tested Git-driven scaling through commit `44a935e`; Argo CD changed the deployment from two to three replicas, then self-healed a manual scale-down from three replicas to one back to the Git-defined count of three.

## AWS end-to-end verification completed

- Provisioned Amazon EKS, Amazon ECR and a stable Jenkins EC2 runner using Terraform.
- Executed Maven tests, SonarQube analysis, Quality Gate enforcement, Docker build and Trivy scanning through Jenkins.
- Remediated critical Tomcat findings by upgrading to version 10.1.59; the final Trivy scan reported zero critical vulnerabilities.
- Pushed immutable image tag `860205de` to ECR and automatically updated the GitOps repository through commit `c46baca`.
- Verified Argo CD application `order-service-dev` was `Synced` and `Healthy`.
- Verified three ready EKS application pods with zero restarts and confirmed the health and order API responses.
- Configured restricted GitHub webhook delivery and validated successful ping and push deliveries to Jenkins.

## Evidence to collect during hands-on execution

| Milestone | Evidence to add |
| --- | --- |
| Maven build | Test summary and packaged JAR |
| Local container | Healthy container and API response |
| Jenkins CI | Successful stage view and archived test report |
| Image security | Trivy result with critical findings resolved |
| Registry | ECR repository with a commit-SHA image tag |
| Kubernetes | Ready pods, service and Helm release |
| GitOps | Argo CD application in Synced and Healthy state |
| Infrastructure | Reviewed Terraform plan and, when applied, EKS outputs |
| Operations | A tested rollback and short troubleshooting note |

No production traffic, uptime, scale, performance or cost-saving figure is claimed by this repository. Those statements should be added only when supported by collected evidence.

