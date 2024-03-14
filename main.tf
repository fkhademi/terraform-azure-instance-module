resource "azurerm_public_ip" "this" {
  count               = var.public_ip ? 1 : 0
  name                = "${var.name}-pub_ip"
  location            = var.region
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  location            = var.region
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.name}-nic"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip ? azurerm_public_ip.this[0].id : null
  }
}

resource "azurerm_network_security_group" "this" {
  name                = "${var.name}-nsg"
  resource_group_name = var.rg
  location            = var.region
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_interface_security_group_association" "lan" {
  count                     = var.azure_additional_nic == [] ? 0 : 1
  network_interface_id      = var.azure_additional_nic[0]
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_security_rule" "this_rfc_1918" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "rfc-1918"
  priority                    = 100
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "this_inbound_tcp" {
  for_each                    = var.inbound_tcp
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "inbound_tcp_${each.key}"
  priority                    = (index(keys(var.inbound_tcp), each.key) + 101)
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefixes     = each.value
  destination_port_range      = each.key
  destination_address_prefix  = "*"
  resource_group_name         = var.rg
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "this_inbound_udp" {
  for_each                    = var.inbound_udp
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "inbound_udp_${each.key}"
  priority                    = (index(keys(var.inbound_tcp), each.key) + 151)
  protocol                    = "Udp"
  source_port_range           = "*"
  source_address_prefixes     = each.value
  destination_port_range      = each.key
  destination_address_prefix  = "*"
  resource_group_name         = var.rg
  network_security_group_name = azurerm_network_security_group.this.name
}

# resource "azurerm_network_security_group" "this" {
#   name                = "${var.name}-nsg"
#   location            = var.region
#   resource_group_name = var.rg

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1004
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "HTTP"
#     priority                   = 1003
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "HTTPS"
#     priority                   = 1005
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "geneve"
#     priority                   = 1010
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "6081"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Internal1"
#     priority                   = 1006
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "10.0.0.0/8"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Internal2"
#     priority                   = 1007
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "172.16.0.0/12"
#     destination_address_prefix = "*"
#   }  

#   security_rule {
#     name                       = "Internal3"
#     priority                   = 1008
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "192.168.0.0/16"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "Outbound"
#     priority                   = 1009
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_network_interface_security_group_association" "this" {
#   network_interface_id      = azurerm_network_interface.this.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

resource "azurerm_virtual_machine" "this" {
  name                         = var.name
  location                     = var.region
  resource_group_name          = var.rg
  network_interface_ids        = concat([azurerm_network_interface.this.id], var.azure_additional_nic)
  primary_network_interface_id = azurerm_network_interface.this.id
  vm_size                      = var.instance_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = var.ubuntu_offer
    sku       = var.ubuntu_version
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.name
    admin_username = "ubuntu"
    custom_data    = var.cloud_init_data
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = var.ssh_key
    }
  }

  depends_on = [
    azurerm_network_interface_security_group_association.this
  ]
}
