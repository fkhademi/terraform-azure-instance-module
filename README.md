# terraform-azure-instance-module
Generic terraform module for deploying Linux VM in Azure

### Usage Example
```
module "srv1" {
  source        = "git::https://github.com/fkhademi/terraform-azure-instance-module.git"

  name      = "frey"
  region    = "North Europe"
  rg        = "rg-av-frey-899789"
  vnet      = "frey"
  subnet    = "frey-Public-gateway-subnet-1"
  ssh_key   = var.ssh_key
  public_ip = true
}

```

### Variables
The following variables are required:

key | value
:--- | :---
name | Azure resource name
region | Azure region
rg | Resource Group where resources should be deployed
vnet | VNET name
subnet | Subnet name where VM should be attached
ssh_key | Public key to be used

The following variables are optional:

key | default | value 
:---|:---|:---
public_ip | false | set to true for a pub ip
ubuntu_version | 18.04-LTS | Ubuntu version to deploy (ie. 20_04-LTS, 20_04-lts-gen2, 22_04-lts-gen2, etc)
ubuntu_offer | UbuntuServer | Ubuntu offer (ie. UbuntuServer, 0001-com-ubuntu-server-focal, 0001-com-ubuntu-server-jammy, etc)
instance_size | Standard_B1ls | The size of the Azure VM instance
cloud_init_data | | cloud init data

### Outputs
This module will return the following outputs:

key | description
:---|:---
vm | The created VM as an object with all of it's attributes. This was created using the azurerm_virtual_machine resource.
nic | The created NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource.
