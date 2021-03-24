
resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}


resource "azurerm_kubernetes_cluster" "k8s" {
  name       = var.aks_name
  location   = azurerm_resource_group.rg.location
  dns_prefix = var.aks_dns_prefix

  resource_group_name = azurerm_resource_group.rg.name

  linux_profile {
    admin_username = var.vm_user_name

    ssh_key {
      key_data = var.public_ssh_key_path
    }
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }

  }

  default_node_pool {
    name            = "agentpool"
    node_count      = var.aks_agent_count
    vm_size         = var.aks_agent_vm_size
    os_disk_size_gb = var.aks_agent_os_disk_size
    vnet_subnet_id  = data.azurerm_subnet.kubesubnet.id
  }

  # block will be applied only if `enable` is true in var.azure_ad object
  role_based_access_control {
    azure_active_directory {
      managed = true
      admin_group_object_ids = var.azure_ad_admin_groups
    }
    enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
  }

  depends_on = [
    azurerm_virtual_network.demo
  ]
  tags = var.tags
}



resource "kubernetes_cluster_role_binding" "aad_integration" {
  metadata {
    name = "${var.aks_name}admins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = var.aks-aad-clusteradmins
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}



# Allows all get list of namespaces, otherwise tools like 'kubens' won't work
resource "kubernetes_cluster_role" "all_can_list_namespaces" {
  depends_on = [azurerm_kubernetes_cluster.k8s]
  for_each   = true ? toset(["ad_rbac"]) : []
  metadata {
    name = "list-namespaces"
  }

  rule {
    api_groups = ["*"]
    resources = [
      "namespaces"
    ]
    verbs = [
      "list",
    ]
  }
}



resource "kubernetes_cluster_role_binding" "all_can_list_namespaces" {
  depends_on = [azurerm_kubernetes_cluster.k8s]
  for_each   = true ? toset(["ad_rbac"]) : []
  metadata {
    name = "authenticated-can-list-namespaces"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.all_can_list_namespaces[each.key].metadata.0.name
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "system:authenticated"
  }
}





