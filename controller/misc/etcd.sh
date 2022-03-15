#!/bin/bash

dnf -y install etcd

echo "#[Member]
ETCD_DATA_DIR=\"/var/lib/etcd/default.etcd\"
ETCD_LISTEN_PEER_URLS=\"http://${CONTROLLER_IP}:2380\"
ETCD_LISTEN_CLIENT_URLS=\"http://${CONTROLLER_IP}:2379\"
ETCD_NAME=\"controller\"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS=\"http://${CONTROLLER_IP}:2380\"
ETCD_ADVERTISE_CLIENT_URLS=\"http://${CONTROLLER_IP}:2379\"
ETCD_INITIAL_CLUSTER=\"controller=http://${CONTROLLER_IP}:2380\"
ETCD_INITIAL_CLUSTER_TOKEN=\"etcd-cluster-01\"
ETCD_INITIAL_CLUSTER_STATE=\"new\"" > /etc/etcd/etcd.conf

firewall-cmd --add-port=2380/tcp --permanent
firewall-cmd --add-port=2379/tcp --permanent
firewall-cmd --reload

systemctl enable etcd
systemctl start etcd