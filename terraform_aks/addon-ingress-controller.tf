locals {
  traefik_settings = {
    deployment = {
      enabled  = true
      replicas = 1
    }

    service = {
      enabled = true
      type    = "LoadBalancer"
      annotations = {
        "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
      }
    }

    resources = {
      requests = {
        cpu    = "500m"
        memory = "500Mi"
      }
      limits = {
        cpu    = "500m"
        memory = "500Mi"
      }
    }
  }
}


resource "kubernetes_namespace" "ingress_controller" {
  metadata {
    name = "ingress-controller"
  }
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]

}


resource "helm_release" "traefik_release" {
  name       = "traefik"
  chart      = "traefik"
  repository = "https://containous.github.io/traefik-helm-chart"
  namespace  = kubernetes_namespace.ingress_controller.metadata[0].name
  version    = "8.0.3"
  timeout    = 1800

  values = [
    yamlencode(local.traefik_settings)
  ]

  depends_on = [kubernetes_namespace.ingress_controller]
}
