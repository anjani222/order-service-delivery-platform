data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  cluster_name = "${var.project_name}-${var.environment}"
  azs          = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.2"

  name = "${local.cluster_name}-vpc"
  cidr = "10.20.0.0/16"
  azs  = local.azs

  private_subnets = ["10.20.1.0/24", "10.20.2.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = var.environment != "prod"
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  name               = local.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_private_access                  = true
  endpoint_public_access                   = true
  endpoint_public_access_cidrs             = var.cluster_endpoint_public_access_cidrs
  enable_cluster_creator_admin_permissions = true
  enabled_log_types                        = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days   = 30
  upgrade_policy = {
    support_type = "STANDARD"
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true
  addons = {
    coredns                = {}
    eks-pod-identity-agent = { before_compute = true }
    kube-proxy             = {}
    vpc-cni                = { before_compute = true }
  }

  eks_managed_node_groups = {
    application = {
      instance_types = var.node_instance_types
      min_size       = 1
      desired_size   = 3
      max_size       = 4
      capacity_type  = "ON_DEMAND"
      labels = {
        workload = "application"
      }
    }
  }
}

resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}/order-service"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration { scan_on_push = true }
  encryption_configuration { encryption_type = "AES256" }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep the latest 20 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
      action = { type = "expire" }
    }]
  })
}
