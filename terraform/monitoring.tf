
# Creates a proxmox_vm_qemu entity named blog_demo_test
resource "proxmox_vm_qemu" "monitoring" {
  name        = "monitoring"
  target_node = var.proxmox_host
  clone       = "ubuntu-jammy" #var.template_name
  full_clone  = "true"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 1024
  scsihw      = "virtio-scsi-pci"
  ipconfig0   = "ip=192.168.30.65/24,gw=192.168.30.1"
  vmid        = "3005"
  bios        = "seabios"  #default value
  qemu_os     = "l26"      #default value

  disk {
    slot    = 0
    size    = "20G"
    type    = "virtio"
    storage = "synology01-LUN"
    discard = "on"
  }

  network {
    model  = "virtio"
    bridge = var.nic_name
    #tag    = var.vlan_num #
  }


  # lifecycle {
  #   ignore_changes = [
  #     network,
  #   ]
  # }

}
