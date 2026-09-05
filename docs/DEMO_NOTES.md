# Demo Notes

This is the sequence I use when walking through the project.

## 1. Start with the problem

The application team needs a repeatable path from commit to Kubernetes. Builds should be traceable, releases should not depend on somebody running commands from a laptop, and reverting a release should leave an audit trail.

## 2. Show the application boundary

The API is deliberately small: list orders, create an order, report health and expose metrics. That leaves enough behaviour to test and monitor without turning this into an application-development exercise.

## 3. Follow one commit

- The pull request runs unit, image, Helm and Terraform checks.
- Jenkins derives an immutable image tag from the commit SHA.
- The image is scanned and pushed to ECR.
- The desired image version is changed in Git.
- Argo CD reconciles the Helm release in EKS.

## 4. Show the controls

In the Deployment manifest, point out the non-root user, read-only root filesystem, resource requests/limits, readiness and liveness probes, rolling-update settings and `/tmp` volume. Then show the HPA and PodDisruptionBudget separately.

## 5. Demonstrate an operational check

```bash
kubectl get pods,service,hpa,pdb -n orders-dev
kubectl logs -n orders-dev deployment/orders-dev-order-service --tail=50
curl http://localhost:8080/actuator/health
```

## 6. Close with rollback

Show the image-tag history, revert one deployment commit and explain that Argo CD restores the previous desired version. Mention that a pushed image is not evidence of a successful release; application health still needs to be observed after reconciliation.

## Short verbal summary

I built this project around a Spring Boot order service to demonstrate the complete delivery path. Terraform provides the AWS networking, EKS cluster and registry. Jenkins tests and scans the change, builds an image tied to the Git SHA and records the new version in Git. Argo CD owns the Kubernetes rollout. Helm carries the workload configuration, and the service exposes health and Prometheus endpoints for operations. For rollback, I revert the deployment commit instead of making an undocumented manual change in the cluster.
