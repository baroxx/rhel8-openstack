#!/bin/bash

. ./constants

# create provider network
openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider
openstack subnet create --network provider --allocation-pool start=${START_IP_ADDRESS},end=${END_IP_ADDRESS} \
  --dns-nameserver ${DNS_RESOLVER} --gateway ${PROVIDER_NETWORK_GATEWAY} \
  --subnet-range ${PROVIDER_NETWORK_CIDR} provider

# create selfservice network
openstack network create selfservice
openstack subnet create --network selfservice \
  --dns-nameserver ${DNS_RESOLVER} --gateway ${SELFSERVICE_NETWORK_GATEWAY} \
  --subnet-range ${SELFSERVICE_NETWORK_CIDR} selfservice

# virtual router for bidirectional NAT
openstack router create router
openstack router add subnet router selfservice
openstack router set router --external-gateway provider