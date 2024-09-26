variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "automation-vyos"
  type        = string
}
variable "resource_group" {
  description = "The name of your Azure Resource Group."
  default     = "vyos_resource_group"
}
variable "hostname" {
  description = "The name of your VM"
  default     = "vyosaz01new"
}
variable "location" {
  description = "The region where the virtual network is created."
  default     = "West Europe"
}
variable "cidr" {
  description = "cidr is used for virtual-network"
  default     = "10.0.0.0/22"
  type        = string
}
variable "pub_subnet" {
  description = "network public that it is used for virtual-network "
  default     = "10.0.2.0/24"
  type        = string
}
variable "vyos_image_id" {
  description = "id image "
  default     = "1.4.0"
  type        = string
}