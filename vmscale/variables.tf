variable "location" {
  description = "The location where resources will be created"
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "dev-vmss-example"
}

variable "application_port" {
    description = "The port that you want to expose to the external load balancer"
    default     = 80
}

variable "admin_password" {
    description = "Default password for admin"
    default = "Password1234!"
}
