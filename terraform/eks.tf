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
      rolearn = module.aws_accounts[student].role-arn, username = student, groups = []
    }
  ]
  map_users = [
    for instructor in local.instructors : {
      userarn = aws_iam_user.instructors[instructor].arn, username = instructor, groups = ["system:masters"]
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
      bootstrap_extra_args = "--use-max-pods false"
      public_ip            = true
    },
  ]
  tags = {
    created-by = "terraform"
  }
}
// TODO: see if we can local-exec and kill the default CNI

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

// Weave to replace the default ENI
// https://medium.com/@swazza85/dealing-with-pod-density-limitations-on-eks-worker-nodes-137a12c8b218
resource "helm_release" "weave" {
  name       = "weave"
  repository = "https://helm.pennlabs.org"
  chart      = "helm-wrapper"
  version    = "0.1.0"
  namespace  = "kube-system"

  values = [file("helm/weave.yaml")]
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://charts.helm.sh/stable"
  chart      = "traefik"
  version    = "1.87.2"
  namespace  = "kube-system"

  values = [file("helm/traefik.yaml")]
}

data "aws_iam_policy_document" "view-k8s" {
  statement {
    actions   = ["eks:DescribeCluster"]
    resources = [module.eks.cluster_arn]
  }
}

resource "helm_release" "registry-creds" {
  name       = "registry-creds"
  repository = "https://helm.pennlabs.org"
  chart      = "helm-wrapper"
  version    = "0.1.0"

  values = [file("helm/registry-creds.yaml")]
}

resource "kubernetes_secret" "cluster-pull-secret" {
  metadata {
    name      = "registry-creds-secret"
    namespace = "kube-system"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://ghcr.io": {
      "auth": "${base64encode("cis188bot:${var.image_pull_pat}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "helm_release" "cluster-pull-secret" {
  name       = "cluster-pull-secret"
  repository = "https://helm.pennlabs.org"
  chart      = "helm-wrapper"
  version    = "0.1.0"
  namespace  = "kube-system"

  values = [file("helm/cluster-pull-secret.yaml")]
  depends_on = [
    helm_release.registry-creds,
    kubernetes_secret.cluster-pull-secret
  ]
}
