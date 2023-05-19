# Description

This will showcase how to setup a proxmox VM template using cloud-init
The process is significantly faster and easier to deal with whenever I need a new Ubuntu VM
Last section is a TL;DR with the commands.

# Steps for the config

## Download the image
Depending on the version, download the image from [Ubuntu Cloud Images](http://cloud-images.ubuntu.com/)

In most cases, select the latest LTS version -> current -> version_name-cloudimg-amd64.img

On the Proxmox Server:

```bash
wget link_to_the_image
```

## Creating the cloud-init yaml file

Make sure that the password in question is hashed and then introduced in the file.
This can by achieved by using the following command:

```bash
python -c "import crypt; print(crypt.crypt('mypassword', crypt.mksalt(crypt.METHOD_SHA512)))"
```

```yaml
#cloud-config
users:
    - name: username
    passwd: password
    ssh_pwauth: True
    lock_passwd: False
    ssh_authorized_keys:
        - ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx user@host
```

## Creating and Configuring the VM

1. Setup the necessary hardware requirements
   - `qm create VMID --memory 4096 --name name-of-vm-template --net0 virtio,bridge=vmbr0 --disk0 size=50G --cores=2`
2. Set the scsi controller, storage and type of disk
   - `qm set VMID --scsiw virtio-scsi-pci --scsi0 local-lvm:vm-VMID-disk-0`
3. Set the cloud-init yaml file (location is **/var/lib/snippets/**)
   - `qm set VMID --cicustom "user=local:snippets/first-run.yaml"`
4. Set the drive to be the first one to boot
   - `qm set VMID --boot c --bootdisk scsi0`
5. Setup the virtual port and VGA display of the VM
   - `qm set VMID --serial0 socket --vga serial0`