# Yum clean
sudo yum clean all

# Cleanup persistent udev rules
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    sudo rm -f /etc/udev/rules.d/70-persistent-net.rules
fi

# Cleanup /tmp directories
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Clean Machine ID
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id

# Remove current SSHd keys
rm -f /etc/ssh/ssh_host_*

# Clear audit logs
if [ -f /var/log/audit/audit.log ]; then
    sudo cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    sudo cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    sudo cat /dev/null > /var/log/lastlog
fi

# Cleanup shell history
cat /dev/null > ~/.bash_history && history -cw


subscription-manager remove --all
subscription-manager clean

# Command below errors as: command not found.
#sys-unconfig
