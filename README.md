DNF Local Plugin Examples
==================

## Description

This repository contains example scripts described in the Fedora Magazine article(https://fedoramagazine.org/use-the-dnf-local-plugin-to-speed-up-your-home-lab/) covering the benefits of the DNF Local Plugin for users that have multiple computers running Fedora on their home or office network. The DNF Local Plugin enables these computers to share a local rpm repository that helps to reduce the amount of dnf related traffic across the internet.

Examples for multiple physical machines, multiple virtual machines, and containers are given.

## Update Notes
Date        | Notes
----------  | -------------------------------
5 Apr 2021  | Generally complete
4 Mar 2021  | Original implementation

## Target
A home or small office network that has multiple Fedora machines. These machines can be VMs running under Vagrant or virt, for example, or physical machines such as a Fedora worksation or a cluster of Raspberry Pi 4s used to host kubernetes. A caching proxy for RPMs is beneficial for both improved performance of DNF across all machines and reduce internet bandwidth consumption, and reduced load on the Fedora mirror community.

## Technical Notes

I used a Fedora Workstation based computer to create these examples. 
