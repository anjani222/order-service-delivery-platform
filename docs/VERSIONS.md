# Version Baseline

Baseline reviewed on 4 September 2026.

| Component | Repository value | Reason |
| --- | --- | --- |
| Java | 21 | Current LTS runtime and consistent with the Jenkins host setup |
| Spring Boot | 3.5.16 | Stable 3.5 line; avoids a major framework migration in a delivery-focused project |
| EKS Kubernetes | 1.36 | In AWS EKS standard support at the time of review |
| Terraform | >= 1.10 | Required for native S3 state locking with `use_lockfile` |
| AWS provider | >= 6.59, < 7.0 | Compatible requirement for the selected EKS module |
| terraform-aws-eks | 21.25.0 | Pinned module release for reproducible plans |
| terraform-aws-vpc | 6.7.2 | Pinned module release for reproducible plans |

References:

- https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
- https://github.com/terraform-aws-modules/terraform-aws-eks/releases
- https://github.com/terraform-aws-modules/terraform-aws-vpc/releases
- https://docs.spring.io/spring-boot/system-requirements.html

Versions are pinned intentionally. Dependabot checks Maven, Docker, GitHub Actions and Terraform dependencies weekly; upgrades should still go through validation rather than being merged automatically.
