#!/bin/bash

dnf -y install mariadb mariadb-server python2-PyMySQL

mkdir /etc/my.cnf.d
echo "[mysqld]
bind-address = ${CONTROLLER_IP}

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8" >> /etc/my.cnf.d/openstack.cnf

systemctl enable mariadb.service
systemctl start mariadb.service