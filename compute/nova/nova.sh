#!/bin/bash

echo "setup nova..."

dnf -y install openstack-nova-compute

cp nova.conf /etc/nova/nova.conf
sed -i "s/RABBIT_PASS/${RABBIT_PASS}/g" /etc/nova/nova.conf
sed -i "s/NOVA_PASS/${NOVA_PASS}/g" /etc/nova/nova.conf
sed -i "s/COMPUTE_IP/${COMPUTE_IP}/g" /etc/nova/nova.conf
sed -zi "s/PLACEMENT_PASS/${PLACEMENT_PASS}/g" /etc/nova/nova.conf
sed -zi "s/NEUTRON_PASS/${NEUTRON_PASS}/g" /etc/nova/nova.conf

systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service