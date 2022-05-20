data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = "192.168.30.11"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "SSD-01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

//  Templates
data "vsphere_virtual_machine" "template_rhel" {
  name          = "RHEL-TPL"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template_win_2019" {
  name          = "WIN2019-TPL"
  datacenter_id = data.vsphere_datacenter.dc.id
}

// Networks
data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}