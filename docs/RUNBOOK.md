# Operations Runbook

## Service health

```bash
kubectl get pods -n orders-dev
kubectl get events -n orders-dev --sort-by=.lastTimestamp
kubectl describe deployment orders-dev-order-service -n orders-dev
kubectl logs -n orders-dev deployment/orders-dev-order-service --tail=200
kubectl port-forward -n orders-dev service/orders-dev-order-service 8080:80
curl http://localhost:8080/actuator/health
```

## Pod is in CrashLoopBackOff

1. Check current and previous container logs.
2. Inspect events for image, scheduling, probe and permission failures.
3. Compare the running image with the Git desired state.
4. Revert the release commit when the new artifact is responsible.

```bash
kubectl logs -n orders-dev <pod> --previous
kubectl describe pod -n orders-dev <pod>
kubectl get deployment orders-dev-order-service -n orders-dev -o jsonpath='{.spec.template.spec.containers[0].image}'
```

## Application is slow

```bash
kubectl top pods -n orders-dev
kubectl get hpa -n orders-dev
kubectl get endpoints -n orders-dev
```

Check CPU/memory saturation, replica scaling, readiness failures, request latency and upstream dependencies. Correlate the start of degradation with the most recent GitOps release.

## Rollback

```bash
git log --oneline -- charts/order-service/values-dev.yaml
git revert <deployment-commit>
git push origin main
argocd app sync order-service-dev
argocd app wait order-service-dev --health --timeout 300
```

## Disaster-recovery considerations

- Terraform code recreates compute/network configuration, but state and data need separate protection.
- Protect Terraform remote state with encryption, versioning, restricted IAM and locking.
- Back up persistent data independently and test restoration against documented RPO/RTO goals.
- Export/retain GitOps configuration and confirm Argo CD can bootstrap from Git.
