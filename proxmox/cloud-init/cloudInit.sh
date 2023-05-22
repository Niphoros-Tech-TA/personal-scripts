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
read -p "$(echo -e "${UBLUE}Enter the VM ID:\n${NC}")" vmID
read -p "$(echo -e "${UBLUE}Enter the name of the VM:\n${NC}")" vmName
read -p "$(echo -e "${UBLUE}Please enter the number of cores: 1 | 2 | 4 \n${NC}")" cores
read -p "$(echo -e "${UBLUE}Please enter RAM size: 2048 | 4096 | 8192 \n${NC}")" ram
read -p "$(echo -e "${UBLUE}Enter disk size (ex. 50):\n${NC}")" diskSize

echo -e "---------------------------"
echo -e "${UPURPLE}VM specific configuration${NC}"
echo -e "---------------------------"
read -p "$(echo -e "${UBLUE}Enter your username:\n${NC}")" usernameVM
read -sp "$(echo -e "${UBLUE}Enter password:\n${NC}")" passwordVM
hashedPassword=$(python3 -c "import crypt; print(crypt.crypt('$passwordVM', crypt.mksalt(crypt.METHOD_SHA512)))")
read -p "$(echo -e "${UBLUE}Enter the SSH Key:\n${NC}")" sshKey


createYaml() {
    username="$1"
    password="$2"
    ssh_key="$3"
    hashed_password=$(python3 -c "import crypt; print(crypt.crypt('$password', crypt.mksalt(crypt.METHOD_SHA512)))")

    echo "#cloud-config
users:
    - name: $username
    passwd: $hashed_password
    ssh_pwauth: True
    lock_passwd: False
    ssh_authorized_keys:
        - $sshKey" > /var/lib/vz/snippets/cloud-config.yaml

}

createYaml "$usernameVM" "$hashedPassword" "$sshKey"

qm importdisk $vmID ./ubuntu-images/$cloudImg
qm set $vmID --scsi1 local-lvm:vm-$vmID-disk-1
qm create $vmID --memory $ram --name $vmName --net0 virtio,bridge=0 --cores=$cores
qm set $vmID --scsihw virtio-scsi-pci --scsi0 local-lvm:$diskSize
qm set $vmID --cicustom "user=local:snippets/cloud-config.yaml"
qm set $vmID --boot c --bootdisk scsi1
qm set $vmID --serial0 socket --vga serial0


qm create $vmID --memory $ram --name $vmName --net0 virtiom,bridge=0 --cores=$cores
