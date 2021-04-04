Virtual Machine Example Using Vagrant
==================

## Description

This directory contains a basic Vagrantfile that starts a Fedora Cloud Image vm including the shared folder containing the host's local DNF repository. The ansible provisioner is commented out. The ansible provisioner will add the plugin automatically via a role. The role is downloaded from a github repository automatically by the vagrant ansible integration.

## Update Notes
Date        | Notes
----------  | -------------------------------
4 April 2021 | Updated to ansible description
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
Run `#sudo dnf update`. The virtual machine will automatically use any rpms in the local repository before retrieving the remaining rpms from a Fedora mirror. The number of rpms pulled from the local repository will depend on how long the dnf local plugin has been in use on the host.

## Ansible Usage

If you are going to provision and update a Fedora VM multiple times or multiple VMs concurrently then an automation tool like Ansible is useful.

For more information on using Ansible I recommend the Ansible for DevOps book by Jeff Geerling (https://www.ansiblefordevops.com/).

Start with the same Vagrantfile and uncomment the ansible provisioning section at the end of the file. (Re)Start Vagrant, i.e.

```
vagrant provision
```

The ansible playbook (./ansible/playbook.yaml) will run, installing the dnf local plugin and then executing a `#dnf update` if the dnf_update flag in the Vagranfile is set to `true`. The `dnf update` will pull most rpms from the local repository shared on `/srv/repodir` by Vagrant. Note that the location of the local repository in the playbook must match the location specified in the Vagrantfile as a shared folder. The number of rpms retrieved from the local repository will depend on how long the repository has been in use on the host.
