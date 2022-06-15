variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
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
