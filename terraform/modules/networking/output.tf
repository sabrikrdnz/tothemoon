output "nic_bastion" {
  value = ["${azurerm_network_interface.bastion.id}"]
}

output "nic_master" {
  value = ["${azurerm_network_interface.master.id}"]
}

output "nic_worker" {
  value = ["${azurerm_network_interface.worker.id}"]
}