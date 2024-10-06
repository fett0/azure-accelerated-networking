# Create a resource group. In Azure every resource belongs to a
# resource group.

resource "azurerm_virtual_network" "vyos_accelerate_network" {
  name                = "${var.namespace}"
  address_space       = ["${var.cidr}"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
}

resource "azurerm_subnet" "vyos_internal" {
  name                 = "vyos-inter"
  resource_group_name  ="${var.resource_group}"
  virtual_network_name = azurerm_virtual_network.vyos_accelerate_network.name
  address_prefixes     = ["${var.pub_subnet}"]
}
resource "azurerm_public_ip" "public_ip" {
  name                = "vyosPublicIp1"
  resource_group_name = "${var.resource_group}"
  location            = "${var.location}"
  sku                     = "Standard"
  allocation_method       = "Static"
  idle_timeout_in_minutes = "30"
}
 
resource "azurerm_network_interface" "vyos_nic" {
  name                 = "vyos_nic"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group}"
  enable_ip_forwarding = true
  enable_accelerated_networking = true
  # enable accelated netwoking on VM - 
  # enable_accelerated_networking = true

  ip_configuration {
    name                          = "vyos_internal"
    subnet_id                     = azurerm_subnet.vyos_internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_security_group" "vyos_nsg" {
  name                = "ports_nsg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # For VxLAN Traffic
  security_rule {
    name                       = "allow_vxlan_sg"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "4789"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vyos_int_sg" {
  network_interface_id      = azurerm_network_interface.vyos_nic.id
  network_security_group_id = azurerm_network_security_group.vyos_nsg.id
}
################################################################################
# VM VyOS Accelerate - Networking 
################################################################################

module "vms" {
  source                      = "./modules/vms"
  hostname                    = var.hostname 
  vyos_image_id               = var.vyos_image_id
  image_publisher_id          = var.image_publisher
  image_offer_id              = var.image_offer
  image_sku_id                = var.image_sku
  resource_group              = var.resource_group
  location                    = var.location
  network_interface_id        = azurerm_network_interface.vyos_nic.id
}


