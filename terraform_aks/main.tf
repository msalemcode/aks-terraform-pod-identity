provider "azurerm" {
  version = "~> 2.51.0"
  features {}
}


terraform {
  required_version = ">= 0.14.8"
  # Backend variables are initialized by Azure DevOps
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.k8s.kube_admin_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.cluster_ca_certificate)}"
  #load_config_file       = false

}



provider "helm" {
  debug = true

  kubernetes {
    host                   = "${azurerm_kubernetes_cluster.k8s.kube_admin_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.cluster_ca_certificate)}"

  }
}
