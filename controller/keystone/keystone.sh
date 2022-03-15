#!/bin/bash

echo "setup keystone..."

mysql -u root --password="" -e "CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '${KEYSTONE_DBPASS}';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '${KEYSTONE_DBPASS}';"

dnf -y install openstack-keystone httpd mod_wsgi

cp ./keystone.conf /etc/keystone/keystone.conf
sed -i "s/KEYSTONE_DBPASS/${KEYSTONE_DBPASS}/g" /etc/keystone/keystone.conf
su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password ${ADMIN_PASS} \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
echo "ServerName controller" >> /etc/httpd/conf/httpd.conf
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

systemctl enable httpd.service
systemctl start httpd.service
firewall-cmd --add-port=5000/tcp --permanent
firewall-cmd --reload

openstack project create --domain default --description "Service Project" service