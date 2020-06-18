terraform {
  required_version = ">= 0.12.0"
}


provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

########################################################################
# Kubernetes Provider
# This allows us to execute commands on a particular kubernetes cluster
# We use this later with the secrets
########################################################################

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
  load_config_file = false
  version = "~> 1.11"
}

data "aws_availability_zones" "available" {
}

########################################################################
# Cluster Name
# You can go to the EKS console and find your cluster with this name
########################################################################

resource "random_string" "suffix" {
  length = 8
  special = false
}

locals {
  cluster_name = "rshiny-aws-${random_string.suffix.result}"
}


########################################################################
# Security Groups
# Let's define some security groups!
########################################################################
resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "worker_group_mgmt_two" {
  name_prefix = "worker_group_mgmt_two"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

########################################################################
# VPC
# Our kubernetes cluster will sit in its own VPC
########################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name = local.cluster_name
  cidr = "10.0.0.0/16"
  azs = data.aws_availability_zones.available.names
  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"]
  public_subnets = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

########################################################################
# EKS Cluster!
########################################################################

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "8.1.0"
  cluster_name = local.cluster_name
  cluster_version = "1.16"
  subnets = module.vpc.private_subnets

  tags = {
    Environment = "test"
    GithubRepo = "terraform-aws-eks"
    GithubOrg = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name = "worker-group-2"
      instance_type = "t2.medium"
      additional_security_group_ids = [
        aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity = 1
    },
  ]
}


########################################################################
# Update the ~/.kube/config
########################################################################

resource "null_resource" "kubectl_update" {
  depends_on = [
    module.eks,
  ]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "aws eks --region $AWS_REGION update-kubeconfig --name $NAME"
    environment = {
      AWS_REGION = var.region
      NAME = local.cluster_name
    }
  }
}

########################################################################
# Polished.tech api secret key
# Add your other secrets - password, API keys, etc
########################################################################

locals {
  secrets = [{ name = "polished"
      data = {
        app_name = var.POLISHED_APP_NAME
        api_key = var.POLISHED_API_KEY
      }},]
}

resource "kubernetes_secret" "main" {
  depends_on = [
    module.eks,
  ]
  count = length(local.secrets)

  metadata {
    name = local.secrets[count.index].name
    //    namespace = var.namespace
    //    labels = merge({}, locals.additional_tags)
    labels = {
      Project = local.cluster_name
      Owner = "terraform"
    }

  }

  data = local.secrets[count.index].data

  type = "Opaque"
}