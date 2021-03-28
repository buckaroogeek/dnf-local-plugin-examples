Custom Fedora Container Build Script
==================

## Description

This directory contains a bash shell script which creates a custom container image based on the generic Fedora container. The custom image includes the DNF Local Plugin that is configured to use a local dnf repository on the host machine.

## Update Notes
Date        | Notes
----------  | -------------------------------
27 Mar 2021  | Original implementation

## Script Technical Notes

The script uses buildah (https://buildah.io) and podman (https://podman.io) to create a custom Fedora container image. The image has the DNF Local Plugin installed and configured to use the default repository location (/var/lib/dnf/plugins/local). This default location is tagged as a mount point in the container so that a repodir on the host machine can be a persistent repository for multiple runs of the container or derivatives.

The basic flow of the script is:
1. download/refresh a current copy of registry.fedoraproject.org/fedora:latest
2. generate minimal configuration file for the plugin. The repository location in the container is the default location - but configurable.
3. install the plugin
4. back up the configuration file and replace with the scratch file
5. tag the repository directory in the image as mountable.
6. write the new image
7. clean up.

## Usage

The script can be executed as a normal user or using sudo. 

As a normal user, the Fedora image and the custom image are stored by podman in the user's local registry. The host mounted repository directory is a directory writeable by the user. The podman example below uses a repodir in the local directory. If this directory is also a git repository you might want to add the repodir to .gitignore. The host mounted repository is not shared with the host dnf. The podman command below starts a container with the custom image and opens a bash shell in the container.

```
podman run -ti -v $pwd/repodir:/var/lib/dnf/plugins/local:Z myfedora /bin/bash
```

If the host has a local dnf repository and you want to share this with the custom container you will need to run the script and podman both as sudo. If, for example, the host repository is at /srv/repodir then:

```
sudo base-image-build.sh
sudo podman run -ti -v /srv/repodir:/srv/repodir:Z myfedora /bin/bash
```
