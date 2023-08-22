# Create an Ubuntu Proxmox Template (Cloud)

## Get the image
1. http://cloud-images.ubuntu.com/ and get the link of the one you want.
2. SSH into your ProxMox Host
3. Download the img:  wget http://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

## Install tools to modify the image, and modify the image
1. apt install libguestfs-tools -y
2. virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent

## Create a vm
1. qm create 9002 --memory 2048 --name ubuntu-jammy --net0 virtio,bridge=vmbr0
2. qm importdisk 9002 jammy-server-cloudimg-amd64.img synology01-LUN
3. qm set 9002 --scsihw virtio-scsi-pci --virtio0 synology01-LUN:vm-9002-disk-0
4. qm set 9002 --ide2 synology01-LUN:cloudinit
5. qm set 9002 --boot c --bootdisk virtio0
6. qm set 9002 --serial0 socket --vga serial0

## Cloud Init & Templatize
1. From UI, find the VM and edit the CloudInit drive
2. Convert it to a template (right click -> conert to tepmlate)