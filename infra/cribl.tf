resource "helm_release" "cribl_leader" {
  name             = "cribl-leader"
  namespace        = var.gcp_app_name
  create_namespace = true
  repository       = "https://criblio.github.io/helm-charts"
  chart            = "logstream-leader"
  version          = "4.4.1"
  values = [
    file("${path.module}/resources/leader.yml")
  ]
  depends_on = [
    module.cribl_k8s_cluster,
  ]
}
