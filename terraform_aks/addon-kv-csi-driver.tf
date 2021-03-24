locals {
  kv_csi_settings = {
    linux = {
      enabled = true
      resources = {
        requests = {
          cpu    = "100m"
          memory = "100Mi"
        }
        limits = {
          cpu    = "100m"
          memory = "100Mi"
        }
      }
    }
    secrets-store-csi-driver = {
      install = true
      linux = {
        enabled = true
      }
      logLevel = {
        debug = true
      }
    }
  }
}


resource "helm_release" "kv_csi" {
  name         = "csi-secrets-store-provider-azure"
  chart        = "csi-secrets-store-provider-azure"
  version      = "0.0.8"
  repository   = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  namespace    = "kube-system"
  max_history  = 4
  atomic       = true
  reuse_values = false
  timeout      = 1800
  values       = [yamlencode(local.kv_csi_settings)]
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]

}
