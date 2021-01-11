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
// TODO: create k8s secret
