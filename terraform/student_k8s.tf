// Create cis 188 student ClusterRole
resource "kubernetes_cluster_role" "student-cluster-role" {
  metadata {
    name = "cis188-student"
  }

  rule {
    api_groups     = [""]
    // resources      = ["pods", "deployments", "configmaps"]
    // TODO: is this too permissive?
    resources      = ["*"]
    verbs          = ["*"]
  }
}


// Configure all student k8s resources
module "k8s_config" {
  for_each    = local.students
  source      = "./modules/k8s_config"
  pennkey     = each.key
  cluster-role-name = kubernetes_cluster_role.student-cluster-role.metadata.name
}
