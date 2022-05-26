#!/usr/bin/env bash
export PACKER_CACHE_DIR=packer_cache

set -e

vm_ssh_password=P@ssw0rd


echo -e "Please enter your choice: \n1) Linux \n2) Windows 2019 DataCenter\n"
while :
do
  read CHOICE
  case $CHOICE in
	1)
    vcenter_username='administrator@stylzz.local'


    read -sp 'vCenter Password: ' vcenter_password
    printf "\n"
    read -sp 'New SSH Password: ' vm_ssh_password_new
    printf "\n"
    read -sp 'RHEL username: ' rh_username
    printf "\n"
    read -sp 'RHEL password: ' rh_password

    export ANSIBLE_VAULT_PASS

    packer build -force \
      -var "vcenter_username=$vcenter_username" \
      -var "vcenter_password=$vcenter_password" \
      -var "vm_ssh_password=$vm_ssh_password" \
      -var "vm_ssh_password_new=$vm_ssh_password_new" \
      -var "rh_username=$rh_username" \
      -var "rh_password=$rh_password" \
      -timestamp-ui \
      templates/redhat.pkr.hcl
		break
		;;
	2)
    printf "Building your windows image...\n"

    packer build -force -var-file=windows2019/vars/vmware.json -var-file=windows2019/vars/vm.json windows2019/machine.json

		break
		;;
  *)
    break
    ;;
  esac
done