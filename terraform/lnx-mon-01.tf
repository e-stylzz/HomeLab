resource "vsphere_virtual_machine" "lnx-mon-01" {
  name             = "LNX-MON-01"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id   = data.vsphere_host.host.id

  guest_id = data.vsphere_virtual_machine.template_rhel.guest_id

  num_cpus = 1
  memory   = 1024

  scsi_type = data.vsphere_virtual_machine.template_rhel.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template_rhel.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template_rhel.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template_rhel.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template_rhel.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_rhel.id

    customize {
      linux_options {
        host_name = "LNX-MON-01"
        domain    = "stylzz.local"
      }

      network_interface {
        ipv4_address = "192.168.30.65"
        ipv4_netmask = 24
      }

      ipv4_gateway = "192.168.30.1"
      dns_suffix_list = ["stylzz.local"]
      dns_server_list = ["192.168.30.50", "192.168.30.51"]
    }
  }
}
