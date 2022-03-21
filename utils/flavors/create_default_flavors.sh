#!/bin/bash

openstack flavor create m1.tiny --id auto --ram 512 --disk 1 --vcpus 1
openstack flavor create m1.small --id auto --ram 2048 --disk 20 --vcpus 1
openstack flavor create m1.medium --id auto --ram 4096 --disk 40 --vcpus 2
openstack flavor create m1.large --id auto --ram 8192 --disk 80 --vcpus 4
openstack flavor create m1.xlarge --id auto --ram 16384 --disk 160 --vcpus 8