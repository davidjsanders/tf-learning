resource "azurerm_container_service" "container_service" {
  name                   = "${var.resource_prefix}-${var.container_service_name}"
  resource_group_name    = "${var.resource_group_name}"
  location               = "${var.location}"
  orchestration_platform = "${var.container_service_orchestrator}"

  master_profile {
    count      = "${var.master_count}"
    dns_prefix = "${var.resource_group_name}-master"
  }

  agent_pool_profile {
    name       = "${var.resource_group_name}-agentpools"
    count      = "${var.agent_count}"
    dns_prefix = "${var.resource_group_name}-agent"
    vm_size    = "${var.agent_sku}"
  }

  linux_profile {
    admin_username = "${var.linux_user}"

    ssh_key {
        key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  service_principal {
    client_id     = "${var.service_principal_client_id}"
    client_secret = "${var.service_principal_client_secret}"
  }

  diagnostics_profile {
    enabled = false
  }

  tags {
    description = "${var.tag_description}"
    env = "${var.tag_environment}"
    prefix = "${var.resource_prefix}"
    orchestrator = "${var.tag_orchestrator}"
  }
}

output "master_fqdn" {
  value = "${azurerm_container_service.container_service.master_profile.fqdn}"
}

output "ssh_command_master" {
  value = "ssh ${var.linux_user}@${azurerm_container_service.container_service.master_profile.fqdn} -A -p 22"
}
