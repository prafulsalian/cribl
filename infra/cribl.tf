resource "helm_release" "cribl_leader" {
  name             = "cribl-leader"
  namespace        = var.gcp_app_name
  create_namespace = true
  repository       = "https://criblio.github.io/helm-charts"
  chart            = "logstream-leader"
  version          = "4.4.3"
  values = [
    file("${path.module}/resources/leader.yml")
  ]
  depends_on = [
    module.cribl_k8s_cluster,
  ]
}

resource "helm_release" "cribl_worker" {
  name             = "cribl-leader"
  namespace        = var.gcp_app_name
  create_namespace = true
  repository       = "https://criblio.github.io/helm-charts"
  chart            = "logstream-leader"
  version          = "4.4.3"
  values = [
    file("${path.module}/resources/worker.yml")
  ]
  depends_on = [
    helm_release.cribl_leader,
  ]
}
