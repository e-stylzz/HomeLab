variable "rh_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "rh_username" {
  type      = string
  default   = ""
  sensitive = true
}

variable "vm_cpu_count" {
  type    = string
  default = "1"
}

variable "vm_disk_size" {
  type    = string
  default = "20480"
}

variable "vm_iso_file" {
  type    = string
  default = "rhel-8.3-x86_64-boot.iso"
}

variable "vm_iso_path" {
  type    = string
  default = "[ISOs] Linux/"
}

variable "vm_name" {
  type    = string
  default = "RHEL9-TPL"
}

variable "vm_network" {
  type    = string
  default = "VM Network"
}

variable "vm_ram_count" {
  type    = number
  default = "1024"
}

variable "vm_scripts" {
  type    = string
  default = "../scripts/00-reg.sh,../scripts/01-update.sh,../scripts/02-sudoers.sh,../scripts/10-banner.sh,../scripts/11-ssh.sh,../scripts/80-post-script-01.sh,../scripts/81-post-script-02.sh,../scripts/89-script-permissions.sh,../scripts/98-cockpit.sh,../scripts/99-cleanup.sh"
}

variable "vm_ssh_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "vm_ssh_password_new" {
  type      = string
  default   = ""
  sensitive = true
}

variable "vm_ssh_username" {
  type    = string
  default = "root"
}

variable "vcenter_cluster" {
  type    = string
  default = "Physical"
}

variable "vcenter_datacenter" {
  type    = string
  default = "Lab"
}

variable "vcenter_datastore" {
  type    = string
  default = "SSD-01"
}

variable "vcenter_host" {
  type    = string
  default = "192.168.30.11"
}

variable "vcenter_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "vcenter_server" {
  type    = string
  default = "192.168.30.10"
}

variable "vcenter_username" {
  type    = string
  default = ""
}

source "vsphere-iso" "redhat" {
  CPUs = var.vm_cpu_count
  RAM  = var.vm_ram_count
  boot_command = [
    "<up><wait>",
    "<tab><wait>",
    "text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/redhat9.cfg",
    "<enter><wait>",
  ]
  boot_wait             = "5s"
  cluster               = var.vcenter_cluster
  convert_to_template   = "true"
  cpu_cores             = 1
  datacenter            = var.vcenter_datacenter
  datastore             = var.vcenter_datastore
  disk_controller_type  = ["pvscsi"]
  folder                = "Templates"
  guest_os_type         = "rhel8_64Guest" 
  host                  = var.vcenter_host
  http_directory        = "preseed"
  insecure_connection   = true
  iso_paths = [
    "[ISOs] Linux/rhel-baseos-9.0-x86_64-dvd.iso"
  ]
  network_adapters {
    network             = var.vm_network
    network_card        = "vmxnet3"
  }
  notes                 = "OS: RHEL 9 Linux\n Date Created: {{isotime \"2006-01-02\"}}"
  password              = var.vcenter_password
  ssh_password          = var.vm_ssh_password
  ssh_username          = var.vm_ssh_username
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = true
  }
  username              = var.vcenter_username
  vcenter_server        = var.vcenter_server
  vm_name               = var.vm_name
  vm_version            = 14
}

build {
  sources = ["source.vsphere-iso.redhat"]

  provisioner "shell" {
    environment_vars = [
      "REDHAT_USERNAME=${var.rh_username}",
      "REDHAT_PASSWORD=${var.rh_password}"
    ]
    inline = [
      "echo Username: $REDHAT_USERNAME",
      "echo Username var: ${var.rh_username}",
      "subscription-manager register --auto-attach --username=$REDHAT_USERNAME --password=$REDHAT_PASSWORD",
      "sudo dnf install perl open-vm-tools -y",
      "sudo yum update -y"
    ]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_CONFIG=../ansible/ansible.cfg", "ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_USER=${var.vm_ssh_username}", "ANSIBLE_SSH_PASS=${var.vm_ssh_password}", "ANSIBLE_BECOME_PASS=${var.vm_ssh_password}"]
    extra_arguments  = ["--extra-vars", "main_password=${var.vm_ssh_password_new} main_user=${var.vm_ssh_username}"]
    playbook_file    = "../ansible/packer-deploy-rhel.yml"
  }

  provisioner "shell" {
    execute_command = "echo 'var.vm_ssh_password' | sudo -S -E {{ .Path }}"
    scripts = [
      "./scripts/10-banner.sh",
      "./scripts/11-ssh.sh",
      "./scripts/80-post-script-01.sh",
      "./scripts/81-post-script-02.sh",
      "./scripts/89-script-permissions.sh",
      "./scripts/98-cockpit.sh",
      "./scripts/99-cleanup.sh"
    ]
  }

}