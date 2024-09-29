provider "aws" {
  region = "us-east-1"
}

# provider "helm" {
#   kubernetes {
#     host = data.aws_eks_cluster.eks.endpoint

#     # client_certificate     = base64decode(data.aws_eks_cluster_auth.eks.client_certificate)
#     # client_key             = base64decode(data.aws_eks_cluster_auth.eks.client_key)
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.eks.token
#   }
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.eks.token
# }

provider "github" {
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66.0"
    }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "~> 2.0"
    # }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "2.18.1"
    # }
    github = {
      source  = "integrations/github"
      version = "~> 6.2.3"
    }
  }
}
