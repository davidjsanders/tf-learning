# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Code set:       variables.tf
# Purpose:        Define the variables used in the terraform.
# Created on:     11 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Environment tag
variable "environment" {
  description = "The environment tag (e.g. dev, prod, test, etc.)"
  default = "dev"
}

# Name tag
variable "name" {
  description = "The tag for identification (and billing) purposes"
  default = "vmssdemo"
}

# Location of the Azure resources
variable "location" {
  description = "The location where resources will be created"
  default     = "East US"
}

# Name of the Azure resource group
variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "dev-vmss-example"
}

# The application port for the webserver
variable "application_port" {
    description = "The port that the external load balancer will route to"
    default     = 8080
}

# The default admin password - this would normally be better defined 
# and controlled as this **IS** source code controlled and available to
# the public.
variable "admin_password" {
    description = "Default password for admin"
    default = "Password1234!"
}