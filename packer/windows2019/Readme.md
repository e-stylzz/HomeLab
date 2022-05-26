# Direct drop in from elsewhere. Still some work to do to:

1. Organine the folder structure better
2. Upgrade to HCL

---

# Execute

## On Linux

packer build -var-file=vars.json server.json

## On Windows

packer build -var-file vars.json server.json

### Requirements

Packer
VMware Environment
7-8 minutes

### What else

Rename vars_TEMPLATE to to just vars(.json) and fill it out as you see fit.

Also, update passwords in autounattend.xml - search for PASSWORD_HERE and your serial (SERIAL_HERE)

### VMware vSphere Builder Docs

https://www.packer.io/docs/builders/vmware/vsphere-iso

### Create Windows Template

packer build -var-file=vars/vmware.json -var-file=vars/vm.json machine.json
