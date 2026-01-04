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
    
    read -p "Enter your $i server ip address: " vm_ip_address
    read -sp "Enter your $i server password: " vm_password && echo
    echo "Check your $i server ip: " $vm_ip_address
    echo "Check your $i server password: " $vm_password

done


# ansible configuration
apt update && apt install -y ansible
for (( i=1; i<=server_count; i++ )); do
    echo "[server_$i]" >> ./dir_to_ignore/hosts.txt
    echo "$vm_ip_address ansible_user=root ansible_ssh_pass=${vm_password}" >> ./dir_to_ignore/hosts.txt
    #unset vm_ip_address
    #unset vm_password
done

ansible-playbook -i ./dir_to_ignore/hosts.txt setup.yml

# clear sensitive data
#    unset vm${i}_ip_address
 #   unset vm${i}_password
