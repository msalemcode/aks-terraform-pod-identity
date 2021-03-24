

locals {
  node_resource_group_id = format("%s/resourceGroups/%s", data.azurerm_subscription.current.id, azurerm_kubernetes_cluster.k8s.node_resource_group)
}

resource "azurerm_role_assignment" "k8s_sa_network_contributor" {
  scope                = azurerm_virtual_network.demo.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.k8s.identity.0.principal_id
}

resource "azurerm_role_assignment" "kubelet_managed_id_operator" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity.0.object_id
}


resource "azurerm_role_assignment" "acr_image_puller" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity.0.object_id
}

resource "azurerm_role_assignment" "acr_reader" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Reader"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity.0.object_id
}


data "azurerm_user_assigned_identity" "agentpool" {
  name                = "${azurerm_kubernetes_cluster.k8s.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}

data "azurerm_resource_group" "node_rg" {
  name = azurerm_kubernetes_cluster.k8s.node_resource_group

}

resource "azurerm_role_assignment" "agentpool_msi" {
  scope                            = data.azurerm_resource_group.node_rg.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = data.azurerm_user_assigned_identity.agentpool.principal_id
  skip_service_principal_aad_check = true

}

resource "azurerm_role_assignment" "agentpool_vm" {
  scope                            = data.azurerm_resource_group.node_rg.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.agentpool.principal_id
  skip_service_principal_aad_check = true
}




