#!/bin/bash

echo "setup neutron..."

dnf -y install openstack-neutron-linuxbridge ebtables ipset

cp neutron.conf /etc/neutron/neutron.conf
sed -i "s/RABBIT_PASS/${RABBIT_PASS}/g" /etc/neutron/neutron.conf
sed -i "s/NEUTRON_PASS/${NEUTRON_PASS}/g" /etc/neutron/neutron.conf
cp linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i "s/PROVIDER_INTERFACE_NAME/${PROVIDER_INTERFACE_NAME}/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i "s/COMPUTE_IP/${COMPUTE_IP}/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
echo "net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.conf 

systemctl restart openstack-nova-compute.service
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-linuxbridge-agent.service