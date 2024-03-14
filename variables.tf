variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "rg" {
  type = string
}

variable "vnet" {
  type = string
}

variable "subnet" {
  type = string
}

variable "azure_additional_nic" {
  default = []
}

variable "ssh_key" {
  type = string
}

variable "inbound_tcp" {
  description = "Inbound TCP Ports"
}

variable "inbound_udp" {
  description = "Inbound UDP Ports"
}

variable "cloud_init_data" {
  default = ""
}

variable "public_ip" {
  default = "false"
}

variable "ubuntu_version" {
  default = "18.04-LTS"
}

variable "ubuntu_offer" {
  default = "UbuntuServer"
}

variable "instance_size" {
  type    = string
  default = "Standard_B1ls"
}
