# OpenStack on RHEL8

This repository provides scripts to setup the key components of OpenStack on RHEL8. 

The [OpenStack Installation Guide](https://docs.openstack.org/install-guide/) contains also steps for SUSE and Ubuntu. The steps for RHEL8 were extracted to this repository. The scripts should also run with minor changes on other DNF based systems. You can find additional information on the [Rocky documentation for OpenStack](https://docs.openeuler.org/en/docs/20.03_LTS_SP2/docs/thirdparty_migration/OpenStack-Rocky.html).

**You should run the script "mysql_secure_installation" to perform security hardening for the database. This script unfortunately requires interactions which cannot be done automatically.**

# Structure

- [compute](compute) - contains the setup scripts for the compute node

    - [neutron](compute/neutron) - neutron setup for compute node
    - [nova](compute/nova) - nova setup for compute node (contains placement and configurations for neutron)

- [controller](controller) - contains the setup script for the controll plane

    - [misc](controller/misc) - setup scripts for components like etcd which are used by OpenStack 
    - [glance](controller/glance) - glance setup for controller node
    - [horizon](controller/horizon) - horizon setup for controller node
    - [keystone](controller/keystone) - keystone setup for controller node
    - [neutron](controller/neutron) - neutron setup for controller node
    - [nova](controller/nova) - nova setup for controller node (contains placement and configurations for neutron)

- [shared](shared) - contains shared content like the constants

# Preperation

1. Set the [constants](shared/constants)
1. Optional: You can comment out or add some further OpenStack components in the setup scripts. There are some shared configurations (for example neutron config in nova)
1. Run [compute setup](compute/setup.sh) or [controller setup](controller/setup.sh)

# Automation with Kickstart

You can combine this script with a Kickstart file to automate the installation via PXE or an USB stick. The repository [rhel8-kickstart](https://github.com/baroxx/rhel8-kickstart/tree/main/rhel8-openstack) provides an example setup. The Kickstart repository also contains scripts for an automated creation of virtual machines with libvirt.

Just run the preperation steps except running the scripts.

# Copyright

The config files in this repository adjusted files based on the default configs. [local_settings](controller/horizon/local_settings) is provided by OpenStack and adjusted in this project.