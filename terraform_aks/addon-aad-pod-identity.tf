locals {
  aad_pod_identity_settings = {
    forceNameSpaced = false
    mic = {
      image = "mic"
      tag   = "1.6.1"
      resources = {
        limits = {
          cpu    = "200m"
          memory = "1024Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "512Mi"
        }
      }
    }
    nmi = {
      image = "nmi"
      tag   = "1.6.1"
      resources = {
        limits = {
          cpu    = "200m"
          memory = "512Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "256Mi"
        }
      }
    }
    rbac = {
      enabled = true
    }
    installCRDs = true
  }
}
resource "helm_release" "aad_pod_identity_release" {
  name         = "aad-pod-identity"
  chart        = "aad-pod-identity"
  version      = "2.0.0"
  repository   = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  namespace    = "kube-system"
  max_history  = 4
  atomic       = true
  reuse_values = false
  timeout      = 1800
  values       = [yamlencode(local.aad_pod_identity_settings)]
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]

}
