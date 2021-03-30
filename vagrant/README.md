Virtual Machine Example Using Vagrant
==================

## Description

This directory contains a basic Vagrantfile that starts a Fedora Cloud Image vm including the shared folder containing the host's local DNF repository. The ansible provisioner is commented out. The ansible provisioner will add the plugin automatically via a role.

## Update Notes
Date        | Notes
----------  | -------------------------------
27 Mar 2021  | Original implementation

## Installation

See https://fedoramagazine.org/vagrant-qemukvm-fedora-devops-sysadmin/ for thorough instructions to install and configure Vagrant on a Fedora system. I also add the following enviroment variable to .bashrc to set the default provider for Vagrant to libvirt.

```
export VAGRANT_DEFAULT_PROVIDER=libvirt
```

Otherwise Vagrant will use VirtualBox.

## Simple Usage

In a new project directory initialize Vagrant with the following command. Substitute the Fedora version with a newer version if appropriate.

```
vagrant init fedora/33-cloud-base 
```

Either edit the resulting `Vagrantfile` to match the Vagrantfile in this directory or download and replace. This `Vagrantfile` adds more memory and shares the host local DNF with the VM (`/srv/repodir`).

Ssh into the virtual machine `$vagrant ssh`, and install the dnf local plugin.

```
#sudo dnf --nodocs -y install python3-dnf-plugin-local createrepo_c
#sudo clean all
#sudo systemctl daemon reload
```
Run dnf update. The virtual machine will automatically use any rpms in the local repository before retrieving the remaining rpms from a Fedora mirror.

## Ansible Usage

If you are going to provision and update a Fedora VM multiple times or multiple VMs concurrently then an automation tool like Ansible is useful.

For more information on using Ansible I recommend the Ansible for DevOps book by Jeff Geerling (https://www.ansiblefordevops.com/).

Start with the same Vagrantfile and uncomment the ansible provisioning section at the end of the file. (Re)Start Vagrant, i.e.

```
vagrant halt
vagrant up
```

The ansible playbook (./ansible/playbook.yaml) will run, installing the dnf local plugin and then executing a `#dnf update` which will pull most rpms from the local repository shared on /srv/repodir by Vagrant.
