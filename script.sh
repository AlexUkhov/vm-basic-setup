#!/bin/bash
#
#
#

# text colors
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color


echo "./dir_to_ignore/" > .gitignore
mkdir -p ./dir_to_ignore/
touch ./dir_to_ignore/hosts.txt
# touch ./hostnames
apt install sshpass
apt install ansible

# data aggregation
read -p "$BLUE How many servers you want to create? $NC" server_count
#echo "You want to create "$server_count" servers"

for (( i=1; i<=server_count; i++ )); do
    echo "Configuring server $i ..."
    read -p "$BLUE Enter your $i server hostname: $NC" hostname
    ssh-keygen -t rsa -b 4096 -f "./dir_to_ignore/$hostname" -N ""
#    echo "Generated key pair for server $i: server_key_$i and server_key_$i.pub"

    read -p "$BLUE Enter your $i server ip address: $NC" ip_address
    read -sp "$BLUE Enter your $i server password: $NC" password && echo
    echo -en "$BLUE Check your $i server hostname: $NC" $hostname
    echo -en "$BLUE Check your $i server ip: $NC" $YELLOW $ip_address $NC
    echo -en "$BLUE Check your $i server password: $NC" $YELLOW $password $NC
    echo "[server_$i]" >> ./dir_to_ignore/hosts.txt
    echo "$hostname ansible_host=$ip_address ansible_user=root ansible_password=${password} ansible_connection=ssh" hostname=$hostname>> ./dir_to_ignore/hosts.txt
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
echo -en "$BLUE Setup is complete! Your SSH keys are stored in $HOME/.ssh/setup/$NC"