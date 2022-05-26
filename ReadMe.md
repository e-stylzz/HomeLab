Home Lab

Ansible
Packer
Terraform

Ansible: Configure servers after creation:
ansible-playbook -i ./hosts -k ./configure_servers.yml (from ansible directory)
TODO: you don't put in a password when prompted. Need to work that out still.

1. Configure VMware Environment (Manual)
2. Build Images with Packer (from packer directory, run the make.sh script)
3. Deploy Systems with Terraform
4. Configure Systems with Ansible

Create Role for Terraform for Azure stuff:
az login
az account list
az account set --subscription="SUB_ID_HERE"
az ad sp create-for-rbac --name="Terraform" --role="Contributor" --scopes="/subscriptions/SUB_ID_HERE"

# Red Hat Subscription Issues?

https://developers.redhat.com/articles/renew-your-red-hat-developer-program-subscription#you_can_t_renew_your_subscription__but_you_can_re_register
