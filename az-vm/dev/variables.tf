variable "name" {
    type="string"
    description="The name of the resource"
    default="noname"
}

variable "location" {
    type="string"
    description="The Azure region where resources should be created"
    default="eastus"
}

variable "org_tla" { 
    default = "lcl" 
}

variable "stage" {
    default = "dv"
}

variable "pip_name" {
    default = "pip"
}

variable "pip_allocation" {
    default = "static"
}

variable "pip_domain" {
    default = "demoapp"
}

variable "nsg_name" {
    default = "netsec"
}

variable "vnet_name" {
    default = "noname"
}

variable "vnet_cidr_block" {
    default = "10.0.0.0/16"
}

variable "subnet_bastion_cidr_block" {
    default = "10.0.1.0/24"
}

variable "subnet_bastion_name" { 
    default = "subnet_bastion"
}

variable "subnet_fe_cidr_block" {
    default = "10.0.2.0/24"
}

variable "subnet_fe_name" { 
    default = "subnet_fe"
}

variable "subnet_be_cidr_block" {
    default = "10.0.3.0/24"
}

variable "subnet_be_name" { 
    default = "subnet_be"
}

variable "description" { }
variable "billing_code" { }
