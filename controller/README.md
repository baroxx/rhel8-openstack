The setup is done in six steps:

1. Preperation: Installs the required repositories and sets the host config
1. Installation and configuration of keystone
1. Installation and configuration of glance
1. Installation and configuration of nova
1. Installation and configuration of neutron
1. Installation and configuration of horizon

The controller ip will be set in [prepare.sh](../shared/prepare.sh) which is called by [setup.sh](setup.sh).You have to add the compute nodes in [prepare.sh](../shared/prepare.sh).