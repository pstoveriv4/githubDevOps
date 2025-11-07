terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
  }
  backend "azurerm" {
    use_azuread_auth     = true
    resource_group_name  = "INFR-Prod-East_US-rg"
    storage_account_name = "eucfiles"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "ac522fb9-7268-4e39-b557-279025247244"
}


resource "azurerm_resource_group" "TF4-rg" {
  location   = "eastus"
  managed_by = null
  name       = "TF4-rg"
  tags = {
    environment = "test"
    iac         = "terraform"
    dateTime    = "250924-1613"
  }
}


resource "azurerm_virtual_network" "terraform-vnet" {
  address_space           = ["10.13.0.0/16"]
  bgp_community           = null
  dns_servers             = []
  edge_zone               = null
  flow_timeout_in_minutes = 30
  location                = "eastus"
  name                    = "terraform-vnet"
  resource_group_name     = "TF4-rg"
  tags                    = {}
}

resource "azurerm_subnet" "terraform-subnet" {
  address_prefixes                              = ["10.13.1.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "terraform-subnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = "TF4-rg"
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  virtual_network_name                          = "terraform-vnet"
}

resource "azurerm_network_interface" "tf-testvm1434" {
  accelerated_networking_enabled = true
  auxiliary_mode                 = null
  auxiliary_sku                  = null
  dns_servers                    = []
  edge_zone                      = null
  internal_dns_name_label        = null
  ip_forwarding_enabled          = false
  location                       = "eastus"
  name                           = "tf-testvm1434"
  resource_group_name            = "TF4-rg"
  tags = {
    environment = "test"
  }
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "ipconfig1"
    primary                                            = true
    private_ip_address                                 = "10.13.1.5"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = null
    subnet_id                                          = "/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/TF4-rg/providers/Microsoft.Network/virtualNetworks/terraform-vnet/subnets/terraform-subnet"
  }
}

resource "azurerm_windows_virtual_machine" "tf-testvm1" {
  admin_password                                         = var.admin_password
  admin_username                                         = "localadmin"
  allow_extension_operations                             = true
  availability_set_id                                    = null
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = null
  computer_name                                          = "tf-testvm1"
  custom_data                                            = null # sensitive
  dedicated_host_group_id                                = null
  dedicated_host_id                                      = null
  disk_controller_type                                   = "SCSI"
  edge_zone                                              = null
  enable_automatic_updates                               = true
  encryption_at_host_enabled                             = false
  eviction_policy                                        = null
  extensions_time_budget                                 = "PT1H30M"
  hotpatching_enabled                                    = false
  license_type                                           = null
  location                                               = "eastus"
  max_bid_price                                          = -1
  name                                                   = "tf-testvm1"
  network_interface_ids                                  = ["/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/TF4-rg/providers/Microsoft.Network/networkInterfaces/tf-testvm1434"]
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "AutomaticByOS"
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = null
  reboot_setting                                         = null
  resource_group_name                                    = "TF4-rg"
  secure_boot_enabled                                    = true
  size                                                   = "Standard_D2s_v3"
  source_image_id                                        = null
  tags = {
    environment = "test"
  }
  timezone                          = null
  user_data                         = null
  virtual_machine_scale_set_id      = null
  vm_agent_platform_updates_enabled = true
  vtpm_enabled                      = true
  zone                              = null
  additional_capabilities {
    hibernation_enabled = false
    ultra_ssd_enabled   = false
  }
  boot_diagnostics {
    storage_account_uri = null
  }
  os_disk {
    caching                          = "ReadWrite"
    disk_encryption_set_id           = null
    disk_size_gb                     = 127
    name                             = "tf-testvm1_OsDisk_1_8cce08deb2404808b4b846133cb49eb6"
    secure_vm_disk_encryption_set_id = null
    security_encryption_type         = null
    storage_account_type             = "Standard_LRS"
    write_accelerator_enabled        = false
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

