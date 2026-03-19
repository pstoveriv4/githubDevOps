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


resource "azurerm_resource_group" "spokeEast-rg" {
  location   = "eastus"
  managed_by = null
  name       = "spokeEast-rg"
  tags = {
    environment = "test"
    iac         = "terraform"
  }
}

resource "azurerm_virtual_network" "spokeEast-vnet" {
  address_space           = ["10.11.0.0/16"]
  bgp_community           = null
  dns_servers             = []
  edge_zone               = null
  flow_timeout_in_minutes = 30
  location                = "eastus"
  name                    = "spokeEast-vnet"
  resource_group_name     = "spokeEast-rg"
  tags                    = {}
}

resource "azurerm_subnet" "spokeEast1-subnet" {
  address_prefixes                              = ["10.11.1.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "spokeEast1-subnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = "spokeEast-rg"
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  virtual_network_name                          = "spokeEast-vnet"
          depends_on = [
    azurerm_virtual_network.spokeEast-vnet
  ]
}

resource "azurerm_network_interface" "spokeEast-vm1-nic" {
  accelerated_networking_enabled = true
  auxiliary_mode                 = null
  auxiliary_sku                  = null
  dns_servers                    = []
  edge_zone                      = null
  internal_dns_name_label        = null
  ip_forwarding_enabled          = false
  location                       = "eastus"
  name                           = "spokeEast-vm1-nic"
  resource_group_name            = "spokeEast-rg"
  tags = {
    environment = "test"
  }
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "ipconfig1"
    primary                                            = true
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = null
    subnet_id                                          = "/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/spokeEast-rg/providers/Microsoft.Network/virtualNetworks/spokeEast-vnet/subnets/spokeEast1-subnet"
  }
        depends_on = [
    azurerm_subnet.spokeEast1-subnet
  ]
}

resource "azurerm_windows_virtual_machine" "spokeEast-vm1" {
  admin_password                                         = var.admin_password
  admin_username                                         = "localadmin"
  allow_extension_operations                             = true
  availability_set_id                                    = null
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = null
  computer_name                                          = "spokeEast-vm1"
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
  name                                                   = "spokeEast-vm1"
  network_interface_ids                                  = ["/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/spokeEast-rg/providers/Microsoft.Network/networkInterfaces/spokeEast-vm1-nic"]
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "AutomaticByOS"
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = null
  reboot_setting                                         = null
  resource_group_name                                    = "spokeEast-rg"
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
    name                             = "spokeEast-vm1_OsDisk_1"
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
    depends_on = [
    azurerm_network_interface.spokeEast-vm1-nic
  ]
}

resource "azurerm_resource_group" "spokeWest-rg" {
  location   = "westus"
  managed_by = null
  name       = "spokeWest-rg"
  tags = {
    environment = "test"
    iac         = "terraform"
  }
}

resource "azurerm_virtual_network" "spokeWest-vnet" {
  address_space           = ["10.13.0.0/16"]
  bgp_community           = null
  dns_servers             = []
  edge_zone               = null
  flow_timeout_in_minutes = 30
  location                = "westus"
  name                    = "spokeWest-vnet"
  resource_group_name     = "spokeWest-rg"
  tags                    = {}
}

resource "azurerm_subnet" "spokeWest1-subnet" {
  address_prefixes                              = ["10.13.1.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "spokeWest1-subnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = "spokeWest-rg"
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  virtual_network_name                          = "spokeWest-vnet"
            depends_on = [
    azurerm_virtual_network.spokeWest-vnet
  ]
}

resource "azurerm_network_interface" "spokeWest-vm1-nic" {
  accelerated_networking_enabled = true
  auxiliary_mode                 = null
  auxiliary_sku                  = null
  dns_servers                    = []
  edge_zone                      = null
  internal_dns_name_label        = null
  ip_forwarding_enabled          = false
  location                       = "westus"
  name                           = "spokeWest-vm1-nic"
  resource_group_name            = "spokeWest-rg"
  tags = {
    environment = "test"
  }
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "ipconfig1"
    primary                                            = true
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = null
    subnet_id                                          = "/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/spokeWest-rg/providers/Microsoft.Network/virtualNetworks/spokeWest-vnet/subnets/spokeWest1-subnet"
  }
      depends_on = [
    azurerm_subnet.spokeWest1-subnet
  ]
}

resource "azurerm_windows_virtual_machine" "spokeWest-vm1" {
  admin_password                                         = var.admin_password
  admin_username                                         = "localadmin"
  allow_extension_operations                             = true
  availability_set_id                                    = null
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = null
  computer_name                                          = "spokeWest-vm1"
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
  location                                               = "westus"
  max_bid_price                                          = -1
  name                                                   = "spokeWest-vm1"
  network_interface_ids                                  = ["/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/spokeWest-rg/providers/Microsoft.Network/networkInterfaces/spokeWest-vm1-nic"]
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "AutomaticByOS"
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = null
  reboot_setting                                         = null
  resource_group_name                                    = "spokeWest-rg"
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
    name                             = "spokeWest-vm1_OsDisk_1"
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
    depends_on = [
    azurerm_network_interface.spokeWest-vm1-nic
  ]
}

resource "azurerm_resource_group" "spokeWest2-rg" {
  location   = "westus"
  managed_by = null
  name       = "spokeWest2-rg"
  tags = {
    environment = "test"
    iac         = "terraform"
  }
}

resource "azurerm_virtual_network" "spokeWest2-vnet" {
  address_space           = ["10.12.0.0/16"]
  bgp_community           = null
  dns_servers             = []
  edge_zone               = null
  flow_timeout_in_minutes = 30
  location                = "westus"
  name                    = "spokeWest2-vnet"
  resource_group_name     = "spokeWest2-rg"
  tags                    = {}
}

resource "azurerm_subnet" "spokeWest2-subnet" {
  address_prefixes                              = ["10.12.1.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "spokeWest2-subnet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = "spokeWest2-rg"
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  virtual_network_name                          = "spokeWest2-vnet"
            depends_on = [
    azurerm_virtual_network.spokeWest2-vnet
  ]
}

resource "azurerm_network_interface" "spokeWest2-vm1-nic" {
  accelerated_networking_enabled = true
  auxiliary_mode                 = null
  auxiliary_sku                  = null
  dns_servers                    = []
  edge_zone                      = null
  internal_dns_name_label        = null
  ip_forwarding_enabled          = false
  location                       = "westus"
  name                           = "spokeWest2-vm1-nic"
  resource_group_name            = "spokeWest2-rg"
  tags = {
    environment = "test"
  }
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "ipconfig1"
    primary                                            = true
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = null
    subnet_id                                          = "/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/spokeWest2-rg/providers/Microsoft.Network/virtualNetworks/spokeWest2-vnet/subnets/spokeWest2-subnet"
  }
      depends_on = [
    azurerm_subnet.spokeWest2-subnet
  ]
}

resource "azurerm_windows_virtual_machine" "spokeWest-vm2" {
  admin_password                                         = var.admin_password
  admin_username                                         = "localadmin"
  allow_extension_operations                             = true
  availability_set_id                                    = null
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = null
  computer_name                                          = "spokeWest2-vm1"
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
  location                                               = "westus"
  max_bid_price                                          = -1
  name                                                   = "spokeWest2-vm1"
  network_interface_ids                                  = ["/subscriptions/ac522fb9-7268-4e39-b557-279025247244/resourceGroups/spokeWest2-rg/providers/Microsoft.Network/networkInterfaces/spokeWest2-vm1-nic"]
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "AutomaticByOS"
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = null
  reboot_setting                                         = null
  resource_group_name                                    = "spokeWest2-rg"
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
    name                             = "spokeWest2-vm1_OsDisk_1"
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
    depends_on = [
    azurerm_network_interface.spokeWest2-vm1-nic
  ]
}