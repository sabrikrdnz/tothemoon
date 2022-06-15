#create resource group
resource "azurerm_resource_group" "tothemoon-rg" {
    name     = var.resource_group_name
    location = var.resource_group_location
    tags      = {
      Environment = "ToTheMoon Demo"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.tothemoon-rg.name
  }
  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.tothemoon-rg.location
  resource_group_name      = azurerm_resource_group.tothemoon-rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "network" {
  source = "./terraform/modules/networking"
  resource_group_location  = var.resource_group_location
  resource_group_name      = var.resource_group_name
}

module "compute" {
  source                   = "./terraform/modules/compute"
  location                 = var.resource_group_location
  resource                 = var.resource_group_name
  nic_bastion              = ["${module.network.nic_bastion[0]}"]
  nic_master               = ["${module.network.nic_master[0]}"]
  nic_worker               = ["${module.network.nic_worker[0]}"]
  tlskey                   = tls_private_key.ssh.public_key_openssh
  storageacc               = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
}