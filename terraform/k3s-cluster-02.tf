# Docs, including other cloud init variables: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#provision-through-cloud-init

resource "proxmox_vm_qemu" "master" {
  name        = "cluster2-mst-01"
  target_node = var.proxmox_host
  clone       = "ubuntu-cloud" #var.template_name
  full_clone  = "true"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 2
  sockets     = 2
  cpu         = "host"
  memory      = 1024
  scsihw      = "virtio-scsi-pci"
#   bootdisk    = "scsi0"
  ipconfig0   = "ip=192.168.30.30/24,gw=192.168.30.1"
  vmid        = "3001"
  bios        = "seabios"  #default value
  qemu_os     = "l26" #default value

  disk {
    slot    = 0
    size    = "20G"
    type    = "virtio"  // was SCSI
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

resource "proxmox_vm_qemu" "worker1" {
  name        = "cluster2-wrk-01"
  target_node = var.proxmox_host
  clone       = "ubuntu-cloud" #var.template_name
  full_clone  = "true"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 1
  sockets     = 4
  cpu         = "host"
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "virtio0"
  ipconfig0   = "ip=192.168.30.31/24,gw=192.168.30.1"
  vmid        = "3002"
  bios        = "seabios"  #default value
  qemu_os     = "l26" #default value

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

resource "proxmox_vm_qemu" "worker2" {
  name        = "cluster2-wrk-02"
  target_node = var.proxmox_host
  clone       = "ubuntu-cloud" #var.template_name
  full_clone  = "true"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 1
  sockets     = 4
  cpu         = "host"
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "virtio0"
  ipconfig0   = "ip=192.168.30.32/24,gw=192.168.30.1"
  vmid        = "3002"
  bios        = "seabios"  #default value
  qemu_os     = "l26" #default value

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

resource "proxmox_vm_qemu" "worker3" {
  name        = "cluster2-wrk-03"
  target_node = var.proxmox_host
  clone       = "ubuntu-cloud" #var.template_name
  full_clone  = "true"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 1
  sockets     = 4
  cpu         = "host"
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "virtio0"
  ipconfig0   = "ip=192.168.30.33/24,gw=192.168.30.1"
  vmid        = "3002"
  bios        = "seabios"  #default value
  qemu_os     = "l26" #default value

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