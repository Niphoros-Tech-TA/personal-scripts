## Provisiong of the VM (mandatory)

The provisioning will be achieved by using Ansible.

To be installed (pending final draft)

```bash
sudo apt-get update && sudo apt-get upgrade -y

# Unnatended upgrade packages (this has to be checked from a security standpoint)

cd /etc/apt/apt.conf.d/
vim/nano 50unattended-upgrades
# below are the lines that should be taken in consideration
"${distro_id}:${distro_codename}";
"${distro_id}:${distro_codename}-security";

# whether to reboot automatically
//Automatically reboot **WITHOUT CONFIRMATION**
//Unattended-upgrade::Automatic-Reboot "false";

# time to reboot automatically
# Default is now
//Unattended-upgrade::Automatic-Reboot-Time "02:00";

# this one I have to check
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";

```

## Provisioning the VM (extra)

This section is mainly targeted to the packages that are nice to have (neovim, ranger) or require a specific type of configuration (highly secure, consistent monitoring)
