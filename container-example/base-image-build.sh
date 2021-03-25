#!/bin/bash
set -x

# bash script that creates a 'myfedora' image from fedora:latest.
# Adds dnf-local-plugin, points plugin to /srv/repodir for local
# repository and creates an external mount point for /srv/repodir
# that can be used with a -v switch in podman/docker

repodir=/srv/repodir

# pull registry.fedoraproject.org/fedora:latest
podman pull registry.fedoraproject.org/fedora:latest

#start the build
mkdev=$(buildah from fedora:latest)

# tag author
buildah config --author "$USER" "$mkdev"

# install dnf-local-plugin, clean
# do not run update as local repo is not operational
buildah run "$mkdev" -- dnf --nodocs -y install python3-dnf-plugin-local createrepo_c
buildah run "$mkdev" -- dnf -y clean all

# create the repo dir
buildah run "$mkdev" -- mkdir -p "$repodir"

# copy the dnf-local-plugin conf file from host - assumes repodir on host
# matches repodir above
buildah copy "$mkdev" "/etc/dnf/plugins/local.conf" "/etc/dnf/plugins/local.conf"

# mark repodir as a mount point for host volume
buildah config --volume "$repodir" "$mkdev"

# create myfedora image
buildah commit "$mkdev" "localhost/myfedora:latest"

# clean up working image
buildah rm "$mkdev"
