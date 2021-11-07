echo "Updating SSH Settings"

#echo "Disabling Root Login"
#/bin/sed -i 's|PermitRootLogin yes|PermitRootLogin no|' /etc/ssh/sshd_config

echo "Setting up the banner."
/bin/sed -i 's|#Banner none|Banner /etc/ssh/sshd-banner|' /etc/ssh/sshd_config

#echo "Changing password auth - both places."
#/bin/sed -i 's|#PasswordAuthentication yes|PasswordAuthentication yes|' /etc/ssh/sshd_config
#/bin/sed -i 's|PasswordAuthentication no|PasswordAuthentication yes|' /etc/ssh/sshd_config