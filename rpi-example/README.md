Raspberry Pi Cluster Example Using Ansible
==================

## Description

This directory contains example Ansible playbooks, inventory, and requirements file that automate the installation and use of the DNF Local Plugin  on a cluster of Raspberry Pis using an NFS share as the shared local dnf repository. The nfs client configuration is also managed. 

## Update Notes
Date        | Notes
----------  | -------------------------------
4 Apr 2021  | Original implementation

## Usage

In a directory containing these files, edit the inventory file to reflect your local set of machines that will have the DNF Local Plugin installed and configured. The default inventory file is in `ini` format, lists 4 devices with names and IP addresses, along with the user name and ssh key ansible will use to connect to each host. The process to set up each host with the correct user profile and ssh key is out of scope for this example but can be done manually or via the tool used to install Fedora on each device. The user id also needs to have sudo privileges. 

The inventory file also contains a variable `dnf_repodir` that is set to the directory on the host system that NFS uses for the file share from the NFS server.

The general base configuration process I used with these Raspberry Pis was to first use the arm-image-installer software to install the image to one Raspberry, ssh to the device and create the target user id, ssh key, sudo privileges and necessary python support for ansible. Then use `dd` on my workstation to copy this image to the storage media for each Pi. Ansible can then be used to customize each Pi with hostname, timezone, and other criteria.

I am sure there are more elegant solutions!

Once the inventory file has been adjusted, install the roles listed in the requirements.yaml file. By convention, ansible will look for a roles subdirectory of the directory containing the playbook. The following command will install the roles in a .\roles subdirectory. There are other roles directory options available. Please see online ansible documentation

```
ansible-galaxy install --roles-path ./roles -r requirements.yaml 
```

Install the nfs client and dnf local plugin using the configure.yaml playbook:

```
ansible-playbook -i inventory configure.yaml
```

Ansible will display basic information for each task as it is executed on each host.

Execute the `update.yaml` playbook to run dnf update serially across all hosts. Ansible will follow the order set in the inventory file. The serial strategy is used to allow the first host to download any rpms as needed, then the subsequent hosts will refresh their dnf local repository metadata which will include all new rpms downloads by the first host.

```
ansible-playbook -i inventory update.yaml
```
