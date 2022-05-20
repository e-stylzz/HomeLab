locals {
  network = {
    name    = "VM Network"
    netmask = "24"
    gateway = "192.168.30.1"
  }
  domain        = "stylzz.local"
  reverse_zone  = "30.168.192.in-addr.arpa"
}