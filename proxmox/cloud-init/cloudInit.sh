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

# This if else statement will check if there is a cloud img already existing in the folder

if [ -f "$fullPath" ]; then
    echo -e "\n Cloud Image already exists"
elif [ ! -f "$fullPath" ]; then
    echo -e "Dowloading image file"
    wget -q --show-progress -P $imgPath $cloudLink
fi

# added some formatting. Colors are present in the colors.sh file.
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

# VM Creation
qm create $vmID --memory $ram --name $vmName --net0 virtio,bridge=vmbr0 --cores=$cores --agent enabled=1

# Importing the VM image
qm importdisk $vmID ./ubuntu-images/$cloudImg local-lvm

# Attach the cloud init configuration
qm set $vmID --ide2 local-lvm:cloudinit

# Setup a separate disk for storage and boot order
qm set $vmID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$vmID-disk-0 --boot order=scsi0

# There are some issues with the resizing and thus I will leave it as a comment here
qm resize $vmID scsi0 +$diskSize

# Set the SCSI HW to virtio-scsi-pci and adds a new scsi disk
# You can create a separate storage if you want to 
## qm set $vmID --scsihw virtio-scsi-pci --scsi1 local-lvm:$diskSize

# Set the output to console
qm set $vmID --serial0 socket --vga serial0

# Cloud-init configuration and set ipv4 dhcp
qm set $vmID --ciuser "$usernameVM" --cipassword "$hashedPassword" --sshkeys ~/.ssh/authorized_keys --ipconfig0 ip=dhcp
