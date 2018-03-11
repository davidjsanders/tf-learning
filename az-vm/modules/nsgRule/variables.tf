variable "nsg_name" { }
variable "rg_name" { }
variable "rule_name" { }
variable "rule_priority" { }
variable "rule_direction" { }
variable "rule_access" { }
variable "rule_protocol" { default = "Tcp" }
variable "rule_source_port" { }
variable "rule_source_address_prefix" { }
variable "rule_dest_port" { }
variable "rule_dest_address_prefix" { }

