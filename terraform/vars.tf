#Set your public SSH key here
variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhkmeAXCHsKFU0jp/2f2tPgpTnOoEJ1pIlEWWFq36rv7Ee7DxL4dRbFVhtqssslzOerRllXAk3aN6Yn7FPvE35jv/x4ONUw97ze87+krwTO3iX78RGRR/TgS4iF+3cv4CFmtVAF15Hszzw1hhAbSFxO5y5LOhs75fH7DJg9FoJY8UVCN5n/WMes1GCIbldsWVWNGhRUtwr1Nn6WnoOzFgEUCmhr8rHZEQDM2yEwEcbaM2/cevKipigpHTvubew5PXk+v7JZwzyeTxbsxbPFtCMfcKthgswSHuZ3kaLV5sJvQ5/XwEDe3X/MlgMvQS1lQAS8cPToKlU2U5mJ4QPbuiyAzmHjM3O9CQz3A4AI1JRq0BuMbl3GqyCHGK4wShVrjLWUeYVuEUxzmvodk0EFc7eAeeTygoD3AK69ezeGn+1kTQ8a0DoAmA3JFDS9U3yKFT7EPv2ZOIYK8hx1pSC68besnEMI9tRnWlf2hV3shx0LpnRr2cnXGJ//j3kyD86JXjt0LH+LAjA60Jqgwrwp2dTTjBqQSSSyM5eWWeIr9lz/3KZEnAXgz3/Hb5LX/apDe/1xZ1lsKKUI8g3L6jF7C4ElOmhtuwGD+ATwqCtcJMddcKyc90/tlHkivDWCx8Fne4yoltukbywrMTIzVap321uX4dFfYcPUNe4CC0ngSRK0Q== eric.barb@gmail.com"
}

#Establish which Proxmox host you'd like to spin a VM up on
variable "proxmox_host" {
    default = "proxmox01"
}

#Specify which template name you'd like to use
variable "template_name" {
    default = "ubuntu-cloud-jellyfish"
}

#Establish which nic you would like to utilize
variable "nic_name" {
    default = "vmbr0"
}

#Establish the VLAN you'd like to use
#variable "vlan_num" {
#    default = "place_vlan_number_here"
#}

#Provide the url of the host you would like the API to communicate on.
#It is safe to default to setting this as the URL for what you used
#as your `proxmox_host`, although they can be different
variable "api_url" {
    default = "https://192.168.30.11:8006/api2/json"
}

#Blank var for use by secrets.tfvars
variable "pm_user" {
    default = "root@pam"
}

#Blank var for use by secrets.tfvars
variable "pm_password" {
}