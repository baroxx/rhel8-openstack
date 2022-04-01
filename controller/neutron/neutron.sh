#!/bin/bash

echo "setup neutron..."

mysql -u root --password="" -e "CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'${HOSTNAME}' IDENTIFIED BY '${NEUTRON_DBPASS}';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '${NEUTRON_DBPASS}';"

openstack user create --domain default --password=${NEUTRON_PASS} neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

dnf -y install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables

cp neutron.conf /etc/neutron/neutron.conf
sed -i "s/NEUTRON_DBPASS/${NEUTRON_DBPASS}/g" /etc/neutron/neutron.conf
sed -i "s/NEUTRON_PASS/${NEUTRON_PASS}/g" /etc/neutron/neutron.conf
sed -i "s/RABBIT_PASS/${RABBIT_PASS}/g" /etc/neutron/neutron.conf
sed -i "s/NOVA_PASS/${NOVA_PASS}/g" /etc/neutron/neutron.conf
cp ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
cp linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i "s/PROVIDER_INTERFACE_NAME/${PROVIDER_INTERFACE_NAME}/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i "s/CONTROLLER_IP/${CONTROLLER_IP}/g" /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp l3_agent.ini /etc/neutron/l3_agent.ini
cp dhcp_agent.ini /etc/neutron/dhcp_agent.ini
echo "net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.conf 
cp metadata_agent.ini /etc/neutron/metadata_agent.ini
sed -i "s/METADATA_SECRET/${METADATA_SECRET}/g" /etc/neutron/metadata_agent.ini
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
setsebool os_neutron_dac_override on

systemctl restart openstack-nova-api.service
systemctl enable neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
systemctl start neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
systemctl enable neutron-l3-agent.service
systemctl start neutron-l3-agent.service
