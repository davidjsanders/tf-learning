variable "tag_environment" { default = "dev" }
variable "tag_description" { default = "Azure Container Services resource group" }
variable "tag_orchestrator" { default = "kubernetes" }
variable "resource_group_name" { default = "acsk8s" }
variable "location" { default = "eastus" }
variable "resource_prefix" { default = "noprefix" }
variable "container_service_name" { default = "containersvc" }
variable "container_service_orchestrator" { default = "Kubernetes" }
variable "master_count" { default = "1" }
variable "agent_count" { default = "3" }
variable "agent_sku" { default = "Standard_D2_v2" }
variable "linux_user" { default = "azureuser" }
variable "service_principal_client_id" {}
variable "service_principal_client_secret" {}
