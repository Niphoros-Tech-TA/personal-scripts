#!/bin/bash
source ./colors.sh
source ./vars.sh


echo -e "---------------------------"
echo -e "${UPURPLE}Download the cloud img version from:${NC}"
echo -e "$cloudImages"
echo -e "---------------------------"
read -p "$(echo -e "Copy paste the link below\n---\n ")" cloudLink

cloudImg=$(basename "$cloudLink")
fullPath="$imgPath/$cloudImg"

if [ -f "$fullPath" ]; then
    echo -e "\n Cloud Image already exists"
elif [ ! -f "$fullPath" ]; then
    echo -e "Dowloading image file"
    wget -q --show-progress -P $imgPath $cloudLink
fi

echo -e "---------------------------"
echo -e "${UPURPLE}Configuring the VM${NC}"
echo -e "---------------------------"
read -p "$(echo -e "Enter the name of the VM")" vmName
read -p "$(echo -e "Please enter the number of cores\n1, 2, 4")" cores
read -p "$(echo -e "Please enter RAM size \n 2048 | 4096 | 8192")" ram
read -p "$(echo -e "Enter disk size (ex. 50G)")" diskSize

echo -e "---------------------------"
echo -e "${UPURPLE}VM specific configuration${NC}"
echo -e "---------------------------"
read -p "$(echo -e "Enter your username")" usernameVM
read -p -s "$(echo -e "Enter password")" passwordVM
$passwordVM = python3 -c "import crypt; print(crypt.crypt('$passwordVM', crypt.mksalt(crypt.METHOD_SHA512)))"
read -p "$(echo -e "Enter the SSH Key")" sshKey


#!/bin/bash

create_yaml() {
    # Take user, password and ssh key as arguments
    user="$1"
    password="$2"
    ssh_key="$3"
    
    # Hash the password
    hashed_password=$(python3 -c "import crypt; print(crypt.crypt('$password', crypt.mksalt(crypt.METHOD_SHA512)))")
    
    # Create the yaml
    echo "#cloud-config
users:
    - name: $user
    passwd: $hashed_password
    ssh_pwauth: True
    lock_passwd: False
    ssh_authorized_keys:
        - $ssh_key" > cloud-config.yaml
}

# Call the function with user, password and ssh key
create_yaml "username" "mypassword" "ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx user@host"
