# Order Service GitOps

This repository holds the desired Kubernetes state for the Order Service development environment. Application CI has write access only for image promotion; Argo CD reads this repository and reconciles the Helm release.

## Layout

```text
charts/order-service/       Helm chart and development values
argocd/application.yaml     Argo CD Application bootstrap manifest
```

## Validate a change

```bash
helm lint charts/order-service -f charts/order-service/values-dev.yaml
helm template orders-dev charts/order-service -f charts/order-service/values-dev.yaml >/tmp/orders-dev.yaml
```

Pull requests run the same lint and render checks through GitHub Actions before a desired-state change is merged.

## Promotion

The Jenkins pipeline in the application repository changes only:

```text
charts/order-service/values-dev.yaml -> image.repository and image.tag
```

The image tag is the short application commit SHA. Manual changes to the live Deployment are not a release method because Argo CD self-heal restores the state recorded here.

## Rollback

Revert the image promotion commit and push the revert to `main`. Argo CD will reconcile the previous image version while preserving the release history in Git.
