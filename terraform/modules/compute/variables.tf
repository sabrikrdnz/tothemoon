variable "resource" {
  type = string
}

variable "location" {
  type = string
}

variable "node_vm_size" {
  description = "Size of nodes"
  type    = string
  default = "Standard_DS1"
}

variable "vnet_name" {
  default = "VNet01"
  type = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24"]
}

variable "tlskey" {}
variable "storageacc" {}
variable "nic_bastion" {}
variable "nic_master" {}
variable "nic_worker" {}

