output "master_fqdn" {
    value = "${module.acs_svc.master_fqdn}"
}

output "ssh_command_master" {
    value = "${module.acs_svc.ssh_command_master}"
}