// Create namespace
resource "kubernetes_namespace" "ns" {
  metadata {
    name var.pennkey
  }
}

resource "kubernetes_role_binding" "rb" {
  metadata {
    name      = "cis188-student-rolebinding"
    namespace = var.pennkey
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.cluster-role-name
  }
  subject {
    kind      = "User"
    name      = var.pennkey
    api_group = "rbac.authorization.k8s.io"
  }
}
