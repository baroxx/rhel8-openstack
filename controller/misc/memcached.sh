#!/bin/bash

dnf -y install memcached python3-memcached

sed -i "s/127.0.0.1,::1/127.0.0.1,::1,controller/g" /etc/sysconfig/memcached

systemctl enable memcached.service
systemctl start memcached.service