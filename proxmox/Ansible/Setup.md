# Introduction

Ansible will rarely be installed on a regular basis, but the instructions would be nice to have.

Two links for references will be added for future-proofing the documentation

[Installation of the application](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installation-guide)
[Getting started](https://docs.ansible.com/ansible/latest/getting_started/index.html)

# Setup

This will focus on the pip version of Ansible.

---
Requirements
- learn how to mark a version of python without risking updating the package
- mark the ansible version
- when ansible is updated, check if the python version supports it.
- separate user to be created that has /bin/false in the config
- 
```bash
$ sudo adduser ansible-user
$ sudo -u ansible-user ssh-keygen
$ sudo -u ansible-user ssh-copy-id target-host
$ sudo chsh -s /bin/false ansible-user
#remove the /bin/false from ansible-user
$ sudo chsh -s /bin/bash ansible-user
$ getent passwd
#only users
$ getent passwd | cut -d: -f1
```