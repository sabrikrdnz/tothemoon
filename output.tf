output "resource_group_name" {
  value = azurerm_resource_group.tothemoon-rg.name
}

output "tls_private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "bastion-public-ip" {
  value     = ["${module.compute.bastion_publicip[0]}"]
}