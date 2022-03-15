#!/bin/bash

# hosts
echo "${CONTROLLER_IP}       controller" > /etc/hosts

# setupntp
echo "server controller iburst" > /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service

# prepare repositories
subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-supplementary-rpms --enable=codeready-builder-for-rhel-8-x86_64-rpms
dnf -y install https://www.rdoproject.org/repos/rdo-release.el8.rpm

# fix centos repos
sed -i 's/\$stream/8-stream/g' /etc/yum.repos.d/advanced-virtualization.repo
sed -i 's/\$stream/8-stream/g' /etc/yum.repos.d/ceph-pacific.repo
sed -i 's/\$stream/8-stream/g' /etc/yum.repos.d/messaging.repo
sed -i 's/\$stream/8-stream/g' /etc/yum.repos.d/nfv-openvswitch.repo
sed -i 's/\$stream/8-stream/g' /etc/yum.repos.d/rdo-release.repo
sed -i 's/\$stream/8-stream/g' /etc/yum.repos.d/rdo-testing.repo
dnf -y upgrade

# install OpenStack client packages
dnf -y install python3-openstackclient openstack-selinux