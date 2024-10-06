# IP Address configuration
output "VyOS_Public_IP_Address" {
  value = azurerm_public_ip.public_ip.ip_address
}
