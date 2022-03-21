#!/bin/bash

readonly DISTRO = "debian"
readonly VERSION = "11"
readonly IMAGE_NAME = "debian-${VERSION}-generic-amd64.qcow2"
readonly IMAGE_URL = "https://cloud.debian.org/images/cloud/bullseye/latest/${IMAGE_NAME}"
readonly FINAL_IMAGE_NAME = "${DISTRO}-${VERSION}-amd64"

curl -L ${IMAGE_URL} > ${IMAGE_NAME}

openstack image create \
    --container-format bare \
    --disk-format qcow2 \
    --property hw_disk_bus=scsi \
    --property hw_scsi_model=virtio-scsi \
    --property os_type=linux \
    --property os_distro=${DISTRO} \
    --property os_admin_user=${DISTRO} \
    --property os_version="${VERSION}" \
    --public \
    --file ${IMAGE_NAME} \
    ${FINAL_IMAGE_NAME}