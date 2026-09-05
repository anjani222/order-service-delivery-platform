variable "aws_region" {
  description = "AWS region for the platform"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Resource name prefix"
  type        = string
  default     = "gitops-platform"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "qa", "staging", "prod"], var.environment)
    error_message = "environment must be dev, qa, staging, or prod."
  }
}

variable "cluster_version" {
  description = "Supported EKS Kubernetes version; verify availability in your region"
  type        = string
  default     = "1.36"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR ranges allowed to reach the public EKS API endpoint"
  type        = list(string)
  default     = ["203.0.113.10/32"]
}

variable "node_instance_types" {
  description = "EKS managed node group instance types"
  type        = list(string)
  default     = ["t3.medium"]
}
