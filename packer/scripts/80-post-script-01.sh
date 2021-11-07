# This creates a setup script that can be run on first boot to simply some things.

# 1) IP Settings
# 2) Computer Name
# 3) Reboot

echo "Creating setup script 1"

cat << 'EOF' >> ./setup-01.sh
# Flag Defaults:
prefix=24
domain=stylzz.local

# Colors
RED='\033[0;31m'
NC='\033[m'


while getopts n:i:g:p:d: flag
do
    case "${flag}" in
        n) computername=${OPTARG};;
        i) ip=${OPTARG};;
        g) gateway=${OPTARG};;
        p) prefix=${OPTARG};;
        d) domain=${OPTARG};;
    esac
done

if [ ! $computername ] || [ $computername = "" ]; then
    echo -e "${RED}ERROR${NC}: No computername.  This is required to proceed."
    exit 1
fi

if [ ! $ip ] || [ $ip = "" ]; then
    echo -e "${RED}ERROR${NC}: No IP Address.  This is required to configure networking."
    exit 1
fi

if [ ! $gateway ] || [ $gateway = "" ]; then
    echo -e "${RED}ERROR${NC}: No gateway.  This is required for internet connectivity."
    exit 1
fi

# Configure IP Settings
echo "IPADDR="$ip >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "PREFIX="$prefix >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "GATEWAY="$gateway >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "DNS1=192.168.30.50" >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "DNS2=192.168.30.51" >> /etc/sysconfig/network-scripts/ifcfg-ens192
echo "DOMAIN="$domain >> /etc/sysconfig/network-scripts/ifcfg-ens192

# Disable DHCP
/bin/sed -i 's|BOOTPROTO=dhcp|BOOTPROTO=none|' /etc/sysconfig/network-scripts/ifcfg-ens192

# Set the hostname
hostnamectl set-hostname $computername


echo "Network settings have been updated and the computer has been renamed.  Rebooting computer..."
sleep 5

reboot now

EOF