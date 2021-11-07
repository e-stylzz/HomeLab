# This creates a setup script that can be run on first boot to simply some things.

# 1) Domain Join
# 2) Insight Client Regisration
# 3) Update as it could have been some time since the vm template was created.

echo "Creating setup script 2"

cat << 'EOF' >> ./setup-02.sh
# Flag Defaults
domain=stylzz.local

# Colors
RED='\033[0;31m'
NC='\033[m'

while getopts u:d: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        d) domain=${OPTARG};;
    esac
done

if [ ! $username ] || [ $username = "" ]; then
    echo -e "${RED}ERROR${NC}: No username.  This is required to join the domain!"
    exit 1
fi

realm join $domain -U $username

echo "Computer has been joined to the domain."
sleep 5

authselect select sssd
authselect select sssd with-mkhomedir
systemctl enable --now oddjobd.service

# Configuring SSSD to not throwup over GPOs
# With RHEL8, things get enforced and without this, logging in with domain credeitals is blocked.
echo "ad_gpo_ignore_unreadable = True" >> /etc/sssd/sssd.conf

insights-client --register

echo "Performing updates"

yum -y update

echo "Rebooting computer..."
sleep 5

reboot now

EOF