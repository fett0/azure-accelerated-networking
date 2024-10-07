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
    public_key = file("files/key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "${var.image_publisher_id}"
    offer     = "${var.image_offer_id}"
    sku       = "${var.image_sku_id}"
    version   = "${var.vyos_image_id}"
  }

  plan {
    publisher = "${var.image_publisher_id}"
    name      = "${var.image_sku_id}"
    product   = "${var.image_offer_id}"
  }
}
