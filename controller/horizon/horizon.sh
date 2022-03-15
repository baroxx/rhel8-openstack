#!/bin/bash

echo "setup horizon..."

dnf -y install openstack-dashboard

cp local_settings /etc/openstack-dashboard/local_settings
sed -i "s/HORIZON_PASS/${HORIZON_PASS}/g" /etc/openstack-dashboard/local_settings
sed -i "s/ALLOWED_HOSTS_VALUE/${ALLOWED_HOSTS_VALUE}/g" /etc/openstack-dashboard/local_settings
echo "WSGIApplicationGroup %{GLOBAL}" >> /etc/httpd/conf.d/openstack-dashboard.conf

systemctl enable httpd.service
systemctl restart httpd.service memcached.service