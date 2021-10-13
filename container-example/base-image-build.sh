#!/bin/bash
set -x

# bash script that creates a 'myfedora' image from fedora:latest.
# Adds dnf-local-plugin, points plugin to /srv/repodir for local
# repository and creates an external mount point for /srv/repodir
# that can be used with a -v switch in podman/docker

# custom image name
custom_name=myfedora

# scratch conf file name
tmp_name=local.conf

# location of plugin config file
configuration_name=/etc/dnf/plugins/local.conf

# location of repodir on container
container_repodir=/srv/repo/f34

# create scratch plugin conf file for container
# using repodir location as set in container_repodir
cat <<EOF > "$tmp_name"
[main]
enabled = true
repodir = $container_repodir
[createrepo]
enabled = true
# If you want to speedup createrepo with the --cachedir option. Eg.
# cachedir = /tmp/createrepo-local-plugin-cachedir
# quiet = true
# verbose = false
EOF

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
buildah run "$mkdev" -- mkdir -p "$container_repodir"

# copy the scratch plugin conf file from host
buildah copy "$mkdev" "$tmp_name" "$configuration_name"

# mark container repodir as a mount point for host volume
buildah config --volume "$container_repodir" "$mkdev"

# create myfedora image
buildah commit "$mkdev" "localhost/$custom_name:latest"

# clean up working image
buildah rm "$mkdev"

# remove scratch file
rm $tmp_name
