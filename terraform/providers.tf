
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
  # pm_log_enable = true
  # pm_log_file = "terraform-plugin-proxmox.log"
  # pm_debug = true
  # pm_log_levels = {
  #   _default = "debug"
  #   _capturelog = ""
  # }
}
