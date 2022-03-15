#!/bin/bash

echo "step 1/3"
. ../shared/constants

bash ../shared/prepare.sh
echo "${COMPUTE_IP}       controller" >> /etc/hosts

echo "step 2/3"
bash ./nova/nova.sh
echo "step 3/3"
bash ./neutron/neutron.sh