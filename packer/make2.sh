#!/usr/bin/env bash
export PACKER_CACHE_DIR=packer_cache

set -e

vm_ssh_password=P@ssw0rd


echo -e "Please enter your choice: \n1) Linux \n2) Windows\n"
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
        break
        ;;

	2)
        printf "Thank you for choosing Windows.  Please make a choice:\n\n"
        echo -e "1) Server 2019 Standard \n2) Server 2019 Core \n3) Server 2022 Standard"
        while :
        do
            read CHOICE
            case $CHOICE in
            1) printf "You chose 2019 DataCenter \n"
            packer build -force -var-file=windows2019/vars/vmware.json -var-file=windows2019/vars/vm.json windows2019/machine.json
               break
               ;;
            2) printf "You chose Core \n"   
               break
               ;;
            3) printf "You choose 2022, we ain't got that shit yet. \n"
               break
               ;;
            *)
               break
               ;;
            esac
        done
        break
        ;;
    *)
        break
        ;;
  esac
done