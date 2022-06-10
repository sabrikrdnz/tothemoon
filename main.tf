#create resource group
resource "azurerm_resource_group" "tothemoon-rg" {
    name     = var.resource_group_name
    location = var.resource_group_location
    tags      = {
      Environment = "ToTheMoon Demo"
    }
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    address_space       = var.address_space
    location            = azurerm_resource_group.tothemoon-rg.location
    resource_group_name = azurerm_resource_group.tothemoon-rg.name
}

# Create subnet
resource "azurerm_subnet" "vm-subnet" {
  name                 = "subnet-uscentral-001"
  resource_group_name  = azurerm_resource_group.tothemoon-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefixes
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "node_publicip"
  location            = azurerm_resource_group.tothemoon-rg.location
  resource_group_name = azurerm_resource_group.tothemoon-rg.name
  allocation_method   = "Static"
}

# Create network security group and rule
resource "azurerm_network_security_group" "tothemoon-nsg" {
  name                = "nsg-001"
  location            = azurerm_resource_group.tothemoon-rg.location
  resource_group_name = azurerm_resource_group.tothemoon-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic01" {
  name                = "NIC01"
  location            = azurerm_resource_group.tothemoon-rg.location
  resource_group_name = azurerm_resource_group.tothemoon-rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic01.id
  network_security_group_id = azurerm_network_security_group.tothemoon-nsg.id
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