
data "azurerm_key_vault" "demokv" {

  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg

}

#Adding namespace
resource "kubernetes_namespace" "demo" {
  metadata {
    name = var.kubernetes_namespace
  }

  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}


# User Assigned Identities 
resource "azurerm_user_assigned_identity" "podIdentity" {
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  location            = var.location
  name                = var.podIdentity
  tags                = var.tags
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]

}


resource "azurerm_key_vault_access_policy" "podIdentity_access_policy" {
  key_vault_id = data.azurerm_key_vault.demokv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azurerm_user_assigned_identity.podIdentity.principal_id

  secret_permissions = [
    "get",
  ]
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]

}


locals {
  settings = {
    fullname     = var.kubernetes_namespace
    key_vault_id = data.azurerm_key_vault.demokv.id
    tenant_id    = data.azurerm_subscription.current.tenant_id
    environment  = "demo"
    managedIdentity = {
      selectorName = var.kubernetes_namespace
      resourceId   = azurerm_user_assigned_identity.podIdentity.id
      clientId     = azurerm_user_assigned_identity.podIdentity.client_id

    }

    ## for the demo - hardcode the values
    secret1 = "appInsightKey"
    secret2 = "cosmosdbKey"


  }
}

resource "helm_release" "azureIdenity" {
  name         = var.kubernetes_namespace
  chart        = "./helm/app"
  namespace    = var.kubernetes_namespace
  max_history  = 4
  atomic       = true
  reuse_values = false
  timeout      = 1800
  values       = [yamlencode(local.settings)]
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]

}
