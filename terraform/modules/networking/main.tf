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
resource "azurerm_public_ip" "bastion" {
  name                = "bastion_publicip"
  location            = azurerm_resource_group.tothemoon-rg.location
  resource_group_name = azurerm_resource_group.tothemoon-rg.name
  allocation_method   = "Static"
}

# Create network interface
resource "azurerm_network_interface" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.tothemoon-rg.location
  resource_group_name = azurerm_resource_group.tothemoon-rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_network_interface" "master" {
  name                = "master"
  location            = azurerm_resource_group.tothemoon-rg.location
  resource_group_name = azurerm_resource_group.tothemoon-rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.8"
  }
}

resource "azurerm_network_interface" "worker" {
  name                = "worker"
  location            = azurerm_resource_group.tothemoon-rg.location
  resource_group_name = azurerm_resource_group.tothemoon-rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.9"
  }
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
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "bastion" {
  network_interface_id      = azurerm_network_interface.bastion.id
  network_security_group_id = azurerm_network_security_group.tothemoon-nsg.id
}
resource "azurerm_network_interface_security_group_association" "master" {
  network_interface_id      = azurerm_network_interface.master.id
  network_security_group_id = azurerm_network_security_group.tothemoon-nsg.id
}
resource "azurerm_network_interface_security_group_association" "worker" {
  network_interface_id      = azurerm_network_interface.worker.id
  network_security_group_id = azurerm_network_security_group.tothemoon-nsg.id
}