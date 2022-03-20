#!/bin/bash

dnf -y install rabbitmq-server

systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service

rabbitmqctl add_user openstack ${RABBIT_PASS}
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

firewall-cmd --add-port=5672/tcp --permanent
firewall-cmd --reload