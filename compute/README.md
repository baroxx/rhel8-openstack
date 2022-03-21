The setup is done in three steps:

1. Preperation: Installs the required repositories and sets the host config
1. Installation and configuration of nova
1. Installation and configuration of neutron

The hosts config is separated. The controller ip will be set in [prepare.sh](../shared/prepare.sh) which is called by [setup.sh](setup.sh). The compute node ip  will be added afterwards in [setup.sh](setup.sh). You have to add other compute nodes in [setup.sh](setup.sh).