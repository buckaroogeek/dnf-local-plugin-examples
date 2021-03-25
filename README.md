DNF Local Plugin Examples
==================

## Description

This repository contains example scripts described in the Fedora Magazine article covering the benefits of the DNF Local Plugin for users that have multiple computers running Fedora on their home or office network. The DNF Local Plugin enables these computers to share a local rpm repository that helps to reduce the amount of dnf related traffic across the internet.

Examples for multiple physical machines, multiple virtual machines, and containers are given.

## Update Notes
Date        | Notes
----------  | -------------------------------
4 Mar 2021  | Original implementation

## Target
A home or small office network that has multiple Fedora machines. These machines can be VMs running under Vagrant or virt, for example, or physical machines such as a Fedora worksation or a cluster of Raspberry Pi 4s used to host kubernetes. A caching proxy for RPMs is beneficial if the internet connection has bandwidth limits or costs. For example, I live in a rural location with a wireless internet connection (Ubiquiti based) that is metered so every bit costs.

## Containerfile (Dockerfile) Notes


## Technical Notes


## Execution

I use a Fedora Workstation based computer to build the container and deploy to a local registry which is then accessed by the docker host. Fedora provides [podman](https://podman.io) as the default tool to build and manage containers. The podman CLI is largely the same as the docker CLI so if docker is your tool of choice, you should be to just substitute docker for podman in the examples below (but I have not tested docker explicitly!).

Start all services in the default docker-compose.yaml file
```bash
sudo docker-compose up
```

Start all services in the default docker-compose.yaml file and detach.
```bash
sudo docker-compose up -d
```

Start the Pi-Hole service in the default docker-compose.yaml file and detach.
```bash
sudo docker-compose up -d pihole
```

Start all services in both docker-compose.yaml files and detach.
```bash
sudo docker-compose up -d -f docker-compose.yaml -f docker-compose-farmos.yaml
```

## Configuration


## Credits

