#!/bin/bash

echo "step 1/3"
. ../shared/constants
bash ../shared/prepare.sh
echo "${CONTROLLER_IP}       controller
${COMPUTE_IP}       compute" > /etc/hosts

echo "step 2/3"
cd nova
bash ./nova.sh
cd ..

echo "step 3/3"
cd neutron
bash ./neutron.sh