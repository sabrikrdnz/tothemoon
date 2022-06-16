resource "azurerm_linux_virtual_machine" "bastion" {
  name                  = "bastion"
  location              = var.location
  resource_group_name   = var.resource
  network_interface_ids = var.nic_bastion
  size                  = var.node_vm_size

  os_disk {
    name                 = "bastionDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "bastion"
  admin_username                  = "bastion"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "bastion"
    public_key = var.tlskey
  }

  boot_diagnostics {
    storage_account_uri = var.storageacc
  }

  tags = {
    environment = "k8sdev"
  }
}

#MASTER
resource "azurerm_linux_virtual_machine" "master" {
  name                  = "master"
  location              = var.location
  resource_group_name   = var.resource
  network_interface_ids = var.nic_master
  size                  = var.node_vm_size

  os_disk {
    name                 = "masterDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "master"
  admin_username                  = "skyfall"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "skyfall"
    public_key = var.tlskey
  }

  boot_diagnostics {
    storage_account_uri = var.storageacc
  }

  tags = {
    environment = "k8sdev"
  }
}

#WORKER
resource "azurerm_linux_virtual_machine" "worker" {
  name                  = "worker"
  location              = var.location
  resource_group_name   = var.resource
  network_interface_ids = var.nic_worker
  size                  = var.node_vm_size

  os_disk {
    name                 = "workerDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "worker"
  admin_username                  = "skyfall"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "skyfall"
    public_key = var.tlskey
  }

  boot_diagnostics {
    storage_account_uri = var.storageacc
  }

  tags = {
    environment = "k8sdev"
  }
}