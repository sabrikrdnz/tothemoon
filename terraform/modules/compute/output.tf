output "bastion_publicip" {
  value = ["${azurerm_linux_virtual_machine.bastion.public_ip_address}"]
}