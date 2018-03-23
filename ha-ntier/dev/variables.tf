variable "ha_zones" { default = 2 }
variable "mgt_region" { default = "eastus2" }
variable "mgt_cidr" { default = "10.10.0.0/16" }
variable "mgt_subnet_cidr" { default = "10.10.1.0/24" }

variable "regions" {
    type = "list"
    default = ["eastus", "westus"]
}

variable "group_names" {
    type = "list"
    default = ["pri", "sec"]
}

variable "cidr_blocks" {
    type = "list"
    default = ["10.0.0.0/16", "10.1.0.0/16"]
}

variable "subnet_mgt_cidr_blocks" {
    type = "list"
    default = ["10.0.1.0/24", "10.1.1.0/24"]
}

variable "subnet_fe_cidr_blocks" {
    type = "list"
    default = ["10.0.2.0/24", "10.1.2.0/24"]
}

variable "subnet_be_cidr_blocks" {
    type = "list"
    default = ["10.0.3.0/24", "10.1.3.0/24"]
}

# Tags
variable "org_tla" { default = "lcl" }
variable "stage" { default = "dv" }
variable "description" { default = "Development env. for XYX" }
variable "billing_code" { default = "L0001" }
variable "app_name" { default = "XYX" }
