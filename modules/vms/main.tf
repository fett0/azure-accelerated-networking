resource "azurerm_linux_virtual_machine" "vyos_test_new" {
  name                            = "${var.hostname}"
  resource_group_name             = "${var.resource_group}"
  location                        = "${var.location}"
  size                            = "Standard_D2s_v3"
  admin_username      = "vyos"
  network_interface_ids = [
    "${var.network_interface_id}",
  ]

  admin_ssh_key {
    username   = "vyos"
    public_key = file("files/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "sentriumsl"
    offer     = "vyos-1-2-lts-on-azure"
    sku       = "vyos-1-3"
    version   = "${var.vyos_image_id}"
  }

  plan {
    publisher = "sentriumsl"
    name      = "vyos-1-3"
    product   = "vyos-1-2-lts-on-azure"
  }
}
