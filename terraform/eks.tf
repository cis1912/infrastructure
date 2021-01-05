module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "13.2.1"
  cluster_name     = local.k8s_cluster_name
  cluster_version  = "1.18"
  subnets          = module.vpc.private_subnets
  vpc_id           = module.vpc.vpc_id
  write_kubeconfig = false
  enable_irsa      = true
  map_roles = [
    for student in var.students : {
      rolearn = modeule.aws_accounts[student].role-arn, username = student, groups = []
    }
  ]
  worker_groups_launch_template = [
    {
      name                    = "spot-1"
      override_instance_types = ["t3.medium"]
      spot_instance_pools     = 1
      // TODO: change to whatever size is needed
      asg_max_size         = 2
      asg_desired_capacity = 2
      kubelet_extra_args   = "--node-labels=node.kubernetes.io/lifecycle=spot"
      public_ip            = true
    },
  ]
  tags = {
    created-by = "terraform"
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

// Spot Node Termination Handler
resource "helm_release" "aws-node-termination-handler" {
  name       = "aws-node-termination-handler"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-node-termination-handler"
  version    = "0.13.0"
  namespace  = "kube-system"

  values = [file("helm/aws-node-termination-handler.yaml")]
}

// Cilium to replace the default ENI
// https://docs.cilium.io/en/v1.9/gettingstarted/k8s-install-eks/
resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.9.1"
  namespace  = "kube-system"

   values = [file("helm/cilium.yaml")] 
}
