provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  load_config_file       = false
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "github" {
  organization = "cis188"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.18"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 1.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13"
    }
    github = {
      source  = "hashicorp/github"
      version = "~> 4.1"
    }
  }
}
