terraform {
  source = "../..//modules/vsphere_vm"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vsphere_host = "192.168.30.11"
  vm_name      = "LNX-MON-01"
  template     = "RHEL-TPL-NEWTEST"

  hardware = {
    num_cpus = 1
    memory   = 1024
  }

  disk = {
    datastore = "SSD-01"
    size      = 20
  }

  vm_ip  = "192.168.30.66"

  domain = "stylzz.local"
}