resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://charts.helm.sh/stable"
  chart      = "prometheus"
  version    = "11.2.3"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [file("helm/prometheus.yaml")]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://charts.helm.sh/stable"
  chart      = "grafana"
  version    = "5.1.4"

  values = [file("helm/grafana.yaml")]
}

resource "random_password" "grafana-password" {
  length  = 64
  special = false
}

resource "kubernetes_secret" "grafana" {
  metadata {
    name = "grafana"
  }

  data = {
    ADMIN_USER                   = "admin"
    ADMIN_PASSWORD               = random_password.grafana-password.result
    GF_AUTH_GITHUB_CLIENT_ID     = var.GF_GH_CLIENT_ID
    GF_AUTH_GITHUB_CLIENT_SECRET = var.GF_GH_CLIENT_SECRET

  }
}
