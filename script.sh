#!/bin/bash
#
#
#
#
echo "./dir_to_ignore/" > .gitignore
mkdir -p ./dir_to_ignore/
touch ./dir_to_ignore/hosts.txt

# data aggregation
read -p "How many servers you want to create? " server_count
echo "You want to create "$server_count" servers"

for (( i=1; i<=server_count; i++ )); do
    ssh-keygen -t rsa -b 4096 -f "./dir_to_ignore/server_key_$i" -N ""
#    echo "Generated key pair for server $i: server_key_$i and server_key_$i.pub"
    
    read -p "Enter your $i server ip address: " ip_address
    read -sp "Enter your $i server password: " password && echo
    echo "Check your $i server ip: " $ip_address
    echo "Check your $i server password: " $password
    echo "[server_$i]" >> ./dir_to_ignore/hosts.txt
    echo "vm$i ansible_host=$ip_address ansible_user=root ansible_password=${password} ansible_connection=ssh" >> ./dir_to_ignore/hosts.txt
    unset ip_address
    unset password
done

# DEBUG
cat ./dir_to_ignore/hosts.txt


# run ansible playbook
ansible-playbook -i ./dir_to_ignore/hosts.txt setup.yml

# clear sensitive data

