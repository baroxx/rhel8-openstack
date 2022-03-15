#!/bin/bash

echo "setup nova with placement..."

mysql -u root --password="" -e "CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '${NOVA_DBPASS}';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '${NOVA_DBPASS}';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '${NOVA_DBPASS}';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '${NOVA_DBPASS}';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY '${NOVA_DBPASS}';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY '${NOVA_DBPASS}';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY '${PLACEMENT_DBPASS}';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY '${PLACEMENT_DBPASS}';"

openstack user create --domain default --password=${NOVA_PASS} nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

openstack user create --domain default --password ${PLACEMENT_PASS} placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778/v3
openstack endpoint create --region RegionOne placement internal http://controller:8778/v3
openstack endpoint create --region RegionOne placement admin http://controller:8778/v3

firewall-cmd --add-port=8774/tcp --permanent
firewall-cmd --reload
firewall-cmd --add-port=8778/tcp --permanent
firewall-cmd --reload

dnf -y install openstack-nova-api openstack-nova-conductor openstack-nova-novncproxy openstack-nova-scheduler openstack-placement-api

cp nova.conf /etc/nova/nova.conf
sed -i "s/NOVA_DBPASS/${NOVA_DBPASS}/g" /etc/nova/nova.conf
sed -i "s/NOVA_PASS/${NOVA_PASS}/g" /etc/nova/nova.conf
sed -i "s/RABBIT_PASS/${RABBIT_PASS}/g" /etc/nova/nova.conf
sed -i "s/PLACEMENT_DBPASS/${PLACEMENT_DBPASS}/g" /etc/nova/nova.conf
sed -i "s/PLACEMENT_PASS/${PLACEMENT_PASS}/g" /etc/nova/nova.conf
sed -i "s/NEUTRON_PASS/${NEUTRON_PASS}/g" /etc/nova/nova.conf
cp placement.conf /etc/placement/placement.conf
sed -i "s/PLACEMENT_DBPASS/${PLACEMENT_DBPASS}/g" /etc/placement/placement.conf
sed -i "s/PLACEMENT_DBPASS/${PLACEMENT_PASS}/g" /etc/placement/placement.conf
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova
su -s /bin/sh -c "placement-manage db sync" placement

systemctl enable openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl restart httpd