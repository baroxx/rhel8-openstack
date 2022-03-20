#!/bin/bash

echo "setup glance..."

mysql -u root --password="" -e "CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'${HOSTNAME}' IDENTIFIED BY '${GLANCE_DBPASS}';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '${GLANCE_DBPASS}';"

openstack user create --domain default --password ${GLANCE_PASS} glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292/v3/
openstack endpoint create --region RegionOne image internal http://controller:9292/v3/
openstack endpoint create --region RegionOne image admin http://controller:9292/v3/
firewall-cmd --add-port=9292/tcp --permanent
firewall-cmd --reload

dnf -y install openstack-glance

cp glance-api.conf /etc/glance/glance-api.conf
sed -i "s/GLANCE_DBPASS/${GLANCE_DBPASS}/g" /etc/glance/glance-api.conf
sed -i "s/GLANCE_PASS/${GLANCE_PASS}/g" /etc/glance/glance-api.conf
firewall-cmd --add-port=11211/tcp --permanent
firewall-cmd --reload
su -s /bin/sh -c "glance-manage db_sync" glance
systemctl enable openstack-glance-api.service
systemctl start openstack-glance-api.service