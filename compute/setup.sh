#!/bin/bash

echo "step 1/3"
. ../shared/constants

bash ../shared/prepare.sh
echo "${COMPUTE_IP}       controller" >> /etc/hosts

echo "step 2/3"
cd nova
bash ./nova.sh
cd ..
echo "step 3/3"
cd neutron
bash ./neutron.sh