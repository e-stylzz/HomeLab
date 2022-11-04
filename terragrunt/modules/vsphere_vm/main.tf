data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.disk.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network.name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id   = data.vsphere_host.host.id

  guest_id = data.vsphere_virtual_machine.template.guest_id

  num_cpus = var.hardware.num_cpus
  memory   = var.hardware.memory

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = var.disk.size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vm_name
        domain    = var.domain
      }

      network_interface {
        ipv4_address = var.vm_ip
        ipv4_netmask = var.network.netmask
      }

      dns_server_list = var.dns.server_list
      dns_suffix_list = var.dns.suffix_list
      ipv4_gateway    = var.network.gateway
    }
  }

  #   provisioner "remote-exec" {
  #     connection {
  #       host     = var.vm_ip
  #       user     = var.vm_user
  #       password = var.vm_password
  #     }
  #     inline = ["echo 'Wait VM creation'"]
  #   }

  #   provisioner "local-exec" {
  #     working_dir = "${var.terraform_root_dir}/../ansible/playbooks"
  #     command     = "ansible-playbook -i ${var.vm_ip}, lvm_resize.yml --extra-vars 'ansible_user=${var.vm_user} ansible_ssh_pass=${var.vm_password}' --ssh-common-args='-o StrictHostKeyChecking=no -o userknownhostsfile=/dev/null'"
  #   }


  #provisioner "local-exec" {
  #  working_dir = "${var.terraform_root_dir}/../ansible"
  #  command     = "ANSIBLE_VAULT_PASS=${var.ansible_vault_pass} ansible-playbook -i ${var.vm_ip}, deploy_terraform.yml --extra-vars 'ansible_user=${var.vm_user} ansible_ssh_pass=${var.vm_password} inventory_hostname=${var.vm_name}.${var.domain}' --ssh-common-args='-o StrictHostKeyChecking=no -o userknownhostsfile=/dev/null'"
  #}
}