resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.5.4"
  namespace  = kubernetes_namespace.cert-manager.metadata[0].name
  // This is set to ensure that cert-manager is working before the CRs are applied
  atomic = true
  set {
    name  = "installCRDs"
    value = true
  }

  // Run the webhook in hostNetwork mode so that the API Server can access it
  // https://github.com/jetstack/cert-manager/blob/95f8d53e19b5dcec1db2d28a2af894ed22ed94db/deploy/charts/cert-manager/values.yaml#L291
  set {
    name  = "webhook.hostNetwork"
    value = true
  }

  set {
    name  = "webhook.securePort"
    value = 10251
  }
}

resource "time_sleep" "cert-manager-cr" {
  // Used to allow cert-manager time to initialize
  depends_on      = [helm_release.cert-manager]
  create_duration = "1m"
}

resource "helm_release" "clusterissuer" {
  name       = "clusterissuer"
  repository = "https://helm.pennlabs.org"
  chart      = "helm-wrapper"
  version    = "0.1.0"
  values     = [file("cert-manager-files/clusterissuer.yaml")]

  depends_on = [
    time_sleep.cert-manager-cr
  ]
}

resource "helm_release" "certs" {
  for_each   = local.users
  name       = "cert-${each.key}"
  repository = "https://helm.pennlabs.org"
  chart      = "helm-wrapper"
  version    = "0.1.0"
  namespace  = each.key
  values     = [templatefile("cert-manager-files/cert.yaml", { NAME = each.key })]

  depends_on = [
    time_sleep.cert-manager-cr
  ]
}

resource "helm_release" "cert-grafana" {
  name       = "cert-grafana"
  repository = "https://helm.pennlabs.org"
  chart      = "helm-wrapper"
  version    = "0.1.0"
  values     = [templatefile("cert-manager-files/cert.yaml", { NAME = "grafana" })]

  depends_on = [
    time_sleep.cert-manager-cr
  ]
}
