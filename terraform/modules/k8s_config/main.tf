// Create namespace
resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.pennkey
  }
}

resource "kubernetes_role_binding" "rb" {
  metadata {
    name      = var.pennkey
    namespace = kubernetes_namespace.ns.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "User"
    name      = var.pennkey
    api_group = "rbac.authorization.k8s.io"
  }
}

// Restrict number of pods
resource "kubernetes_resource_quota" "pod-limit" {
  metadata {
    name = "pod-limit"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }
  spec {
    hard = {
      pods = 10
    }
    scopes = ["BestEffort"]
  }
}
