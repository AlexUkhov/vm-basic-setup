#!/bin/bash
#
#
#
#

echo "./dir_to_ignore/" > .gitignore
mkdir -p ./dir_to_ignore/
touch ./dir_to_ignore/hosts.txt
# touch ./hostnames
apt install sshpass
apt install ansible

# data aggregation
read -p "How many servers you want to create? " server_count
#echo "You want to create "$server_count" servers"

for (( i=1; i<=server_count; i++ )); do
    echo "Configuring server $i ..."
    read -p "Enter your $i server hostname: " hostname
    ssh-keygen -t rsa -b 4096 -f "./dir_to_ignore/$hostname" -N ""
#    echo "Generated key pair for server $i: server_key_$i and server_key_$i.pub"
    
    read -p "Enter your $i server ip address: " ip_address
    read -sp "Enter your $i server password: " password && echo
    echo "Check your $i server hostname: " $hostname
    echo "Check your $i server ip: " $ip_address
    echo "Check your $i server password: " $password
    echo "[server_$i]" >> ./dir_to_ignore/hosts.txt
    echo "$hostname ansible_host=$ip_address ansible_user=root ansible_password=${password} ansible_connection=ssh" >> ./dir_to_ignore/hosts.txt
   # alias $hostname="ssh -i $HOME/.ssh/setup/$hostname root@$ip_address"
   # echo "$hostname" >> ./hostnames
    unset ip_address
    unset password
    unset hostname
done

# DEBUG
cat ./dir_to_ignore/hosts.txt


# run ansible playbook
ansible-playbook -i ./dir_to_ignore/hosts.txt setup.yml

# clear sensitive data
rm -f ./dir_to_ignore/hosts.txt

mkdir -p $HOME/.ssh/setup/
mv ./dir_to_ignore/* $HOME/.ssh/setup/
chmod 700 $HOME/.ssh/setup/
chmod 600 $HOME/.ssh/setup/*
rm -rf ./dir_to_ignore/

# final message
echo "Setup is complete! Your SSH keys are stored in $HOME/.ssh/setup/"