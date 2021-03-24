
data "azurerm_lb" "aks_internal" {
  name                = "kubernetes-internal"
  resource_group_name = "MC_aks-identity-demo_demo-cluster_eastus2"
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}

resource "azurerm_dns_a_record" "dns_dev_api" {
  name                = var.lb_api_record
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_rg
  ttl                 = 300
  records             = [data.azurerm_lb.aks_internal.private_ip_address]
}
