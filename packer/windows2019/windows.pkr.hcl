variable "admin_password" {
  type      = string
  default   = "P@ssw0rd"
  sensitive = true
}

variable "admin_username" {
  type      = string
  default   = "Administrator"
  sensitive = true
}

variable "ansible_serviceaccount_password" {
    type    = string
    default = ""
    sensitive = true
}

variable "vm_cpu_count" {
  type    = string
  default = "1"
}

variable "vm_disk_size" {
  type    = string
  default = "40960"
}

variable "vm_name" {
  type    = string
  default = "WIN2019-TPL2"
}

variable "vm_network" {
  type    = string
  default = "VM Network"
}

variable "vm_ram_count" {
  type    = number
  default = "4096"
}

variable "vm_scripts" {
  type    = list(string)
  default = [
      "windows2019/scripts/step2.ps1"
  ]
}

variable "vm_admin_password_new" {
  type      = string
  default   = ""
  sensitive = true
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

packer {
    required_plugins {
        vsphere = {
            version = ">= v1.0.2"
            source = "github.com/hashicorp/vsphere"
        }
    }

    required_plugins {
        ansible = {
            version = ">= 1.0.2"
            source  = "github.com/hashicorp/ansible"
        }
    }
}

source "vsphere-iso" "windows" {
  CPUs = var.vm_cpu_count
  RAM  = var.vm_ram_count
  vcenter_server        = var.vcenter_server
  insecure_connection   = true
  username              = var.vcenter_username
  password              = var.vcenter_password
  datacenter            = var.vcenter_datacenter
  vm_name               = var.vm_name
  notes                 = "OS: Server 2019 Datacenter\nDate Created: {{isotime \"2006-01-02\"}}"
  folder                = "Templates"
  cluster               = var.vcenter_cluster
  host                  = var.vcenter_host
  datastore             = var.vcenter_datastore
  disk_controller_type  = ["pvscsi"]
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = true
  }
  network_adapters {
    network             = var.vm_network
    network_card        = "vmxnet3"
  }
  convert_to_template   = "true"
  guest_os_type         = "windows9Server64Guest"
  communicator          = "winrm"
  winrm_username        = var.admin_username
  winrm_password        = var.admin_password
  boot_order            = "disk,cdrom"
  iso_paths             = [
      "[ISOs] Windows/SW_DVD9_Win_Server_STD_CORE_2019_1809.6_64Bit_English_DC_STD_MLF_X22-34397.ISO",
	  "[] /vmimages/tools-isoimages/windows.iso"
  ]
  floppy_files          = [
      "windows2019/config/autounattend.xml",
      "windows2019/scripts/install-vmtools.ps1",
      "windows2019/scripts/step1.ps1"
  ]
  remove_cdrom          = true

  shutdown_command      = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Build Complete\""
}

build {
  sources = ["source.vsphere-iso.windows"]
  provisioner "powershell" {
      elevated_user = var.admin_username
      elevated_password = var.admin_password
      scripts = var.vm_scripts
  }

  provisioner "powershell" {
    environment_vars = ["TEST=${var.vm_admin_password_new}"]
    inline = ["Write-Host \"Admin Password: $Env:TEST\""]
  }

  provisioner "ansible" {
    playbook_file     = "../ansible/packer-deploy-win.yml"
    user              = "Administrator"
    use_proxy         = false
    ansible_env_vars  = ["no_proxy=\"*\""]
    extra_arguments   = [
      "-vvvv",
      "-e",
      "ansible_winrm_server_cert_validation=ignore ansible_serviceaccount_password=${var.ansible_serviceaccount_password} vm_admin_password_new=${var.vm_admin_password_new}"
    ]   
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

}