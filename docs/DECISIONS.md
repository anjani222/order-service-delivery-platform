# Engineering Decisions

These notes capture the reasoning behind choices that are otherwise easy to miss when looking only at YAML files.

## 1. Git SHA image tags

**Decision:** Use the short source commit SHA as the container tag.

**Reason:** A running image can be traced back to one code revision. It also avoids mutable environment tags such as `latest`.

**Trade-off:** A release label is easier for people to remember. In a team setup I would retain the SHA/digest and add release metadata rather than replace traceability.

## 2. Argo CD owns cluster deployment

**Decision:** Jenkins updates desired state in Git but does not run a production `kubectl apply`.

**Reason:** Git remains the release record, and Argo CD can report drift and restore the declared state.

**Trade-off:** The pipeline is asynchronous: a successful image push is not the same as a healthy deployment. Deployment health must be observed in Argo CD and monitoring.

## 3. Separate application and GitOps repositories

**Decision:** Keep application CI and environment desired state in separate Git repositories.

**Reason:** A manifest-only commit must not retrigger an application build and generate another image SHA. Separation also allows tighter write access and environment-specific reviews.

**Trade-off:** Initial setup requires two repositories. The `gitops-repository/` directory in this download is seed content that is pushed once to `order-service-gitops`.

## 4. Private EKS worker subnets

**Decision:** Place worker nodes in private subnets and route application traffic through ingress.

**Reason:** Nodes do not require direct inbound internet exposure.

**Trade-off:** Private outbound access through NAT has a cost. VPC endpoints and workload requirements should be evaluated for a real environment.

The public API endpoint remains enabled for the lab, but access is restricted to an explicit `/32` CIDR. Private endpoint access and EKS control-plane audit logs are enabled.

## 5. Conservative container permissions

**Decision:** Run as UID 10001, drop capabilities, use a read-only root filesystem and mount only an ephemeral `/tmp`.

**Reason:** The service does not need root or write access to its image filesystem.

**Trade-off:** Applications that write local files need explicit writable volumes; the permission model must be tested rather than copied blindly.

## 6. Prometheus integration is opt-in

**Decision:** Expose Actuator metrics but keep ServiceMonitor disabled by default.

**Reason:** A standard Kubernetes cluster does not contain the Prometheus Operator CRD. Enabling the custom resource before the operator exists would fail the deployment.
