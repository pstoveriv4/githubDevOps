variable "resource_group_name" {
  default = "TF2-rg"
}
variable "virtual_network_name" {
  default = "TF1-vnet"
}
variable "admin_password" {
  default   = "301Pbbs804!!!"
  type      = string
  sensitive = true
}

