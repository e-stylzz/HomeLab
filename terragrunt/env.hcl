locals {
  vsphere_datacenter = "Lab"
  vsphere_cluster    = "Physical"
  dns = {
    server_list = ["192.168.30.50", "192.168.30.51"]
    suffix_list = ["stylzz.local"]
  }
  terraform_root_dir = get_parent_terragrunt_dir()
}