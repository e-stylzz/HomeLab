locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  network_vars = read_terragrunt_config(find_in_parent_folders("network.hcl"))

  vsphere_server   = local.account_vars.locals.vsphere_server
  vsphere_user     = local.account_vars.locals.vsphere_user
  vsphere_password = local.account_vars.locals.vsphere_password

  vm_user            = local.account_vars.locals.vm_user
  vm_password        = local.account_vars.locals.vm_password

  ansible_vault_pass = local.account_vars.locals.ansible_vault_pass

  vsphere_datacenter = local.env_vars.locals.vsphere_datacenter
  vsphere_cluster    = local.env_vars.locals.vsphere_cluster
  dns                = local.env_vars.locals.dns

  network = local.network_vars.locals.network
  domain  = local.network_vars.locals.domain

  terraform_root_dir = local.env_vars.locals.terraform_root_dir
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.0.0"
    }
  }
}
provider "vsphere" {
  vsphere_server        = "${local.vsphere_server}"
  user                  = "${local.vsphere_user}"
  password              = "${local.vsphere_password}"
  allow_unverified_ssl  = true
}
EOF
}

inputs = merge(
  local.account_vars.locals,
  local.env_vars.locals,
  local.network_vars.locals
)