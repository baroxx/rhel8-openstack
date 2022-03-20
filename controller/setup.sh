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
cd keystone
bash ./keystone.sh
cd ..

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