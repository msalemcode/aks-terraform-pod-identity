variable "aks-aad-srv-id" {
  description = "Existing AAD SP server ID"
}

variable "aks-aad-srv-secret" {
  description = "Existing AAD SP server secret"
}


variable "aks-aad-client-id" {
  description = "Existing AAD SP Client ID"
}


variable "aks-aad-clusteradmins" {
  description = " Name of the Existing admin group."
  default     = "demo-clusteradmin"
}


variable "resource_group_name" {
  description = "Name of the resource group."
  default     = "aks-identity-demo"
}

variable "location" {
  description = "Location of the cluster."
  default     = "eastus2"
}

variable "virtual_network_name" {
  description = "Virtual network name"
  default     = "aksVirtualNetwork"
}

variable "virtual_network_address_prefix" {
  description = "VNET address prefix"
  default     = "15.0.0.0/8"
}

variable "aks_subnet_name" {
  description = "Subnet Name."
  default     = "kubesubnet"
}

variable "aks_subnet_address_prefix" {
  description = "Subnet address prefix."
  default     = "15.0.0.0/16"
}


variable "container_registry_name" {

  description = "Container Registry name"
  default     = "ENTER NAME HERE"
}

variable "key_vault_name" {
  description = "Existing key vault name"
  default     = "ENTER NAME HERE"
}


variable "key_vault_rg" {
  description = "Existing key vault rg"
  default     = "demo-apps" # ENTER NAME HERE
}


variable "aks_name" {
  description = "AKS cluster name"
  default     = "demo-cluster" # ENTER NAME HERE
}
variable "aks_dns_prefix" {
  description = "Optional DNS prefix to use with hosted Kubernetes API server FQDN."
  default     = "aks"
}


variable "aks_agent_count" {
  description = "The number of agent nodes for the cluster."
  default     = 3
}

variable "aks_agent_vm_size" {
  description = "VM size"
  default     = "Standard_B2s"
}

variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
  default     = 40
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.11.5"
}

variable "aks_service_cidr" {
  description = "CIDR notation IP range from which to assign service cluster IPs"
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "DNS server IP address"
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}

variable "aks_enable_rbac" {
  description = "Enable RBAC on the AKS cluster. Defaults to false."
  default     = "false"
}

variable "vm_user_name" {
  description = "User name for the VM"
  default     = "vmuser1"
}

variable "public_ssh_key_path" {
  description = "Public key path for SSH."
  default     = "Enter PK HERE"
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
  }
}

variable "azure_ad_admin_groups" {
  description = "This list of groups Priniciple Ids who will be bounded to cluster-Admin role to get full Admin rights for this cluster. This used only if `azure_ad` is enabled"
  type        = list(string)
  default     = [Enter GUID HERE]
  
}

variable "podIdentity" {
  description = "AKS pod identity"
  default     = "demoIdentity"
}

variable "kubernetes_namespace" {
  description = "AKS namespace"
  default     = "demo"
}

