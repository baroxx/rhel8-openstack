#!/bin/bash

echo "step 1/6"
. ../shared/constants

# preparation and installation of non OpenStack components
bash ../shared/prepare.sh
bash ./misc/mariadb.sh
bash ./misc/rabbitmq.sh
bash ./misc/memcached.sh
bash ./misc/etcd.sh

echo "step 2/6"
bash ./keystone/keystone.sh
# create admin-opencr
echo "export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2" > ../shared/admin-openrc
. ../shared/admin-openrc

echo "step 3/6"
cd glance
bash ./glance.sh
cd ..
echo "step 4/6"
cd nova
bash ./nova.sh
cd ..
echo "step 5/6"
cd neutron
bash ./neutron.sh
cd ..
echo "step 6/6"
cd horizon
bash ./horizon.sh