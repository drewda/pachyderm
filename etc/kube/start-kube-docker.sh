#!/bin/bash

set -Ee

# Prints a spinning wheel. Every time you call it, the wheel advances 1/4 turn
WHEEL="-\|/"
spin() {
    echo -en "\e[D${WHEEL:0:1}"
    WHEEL=${WHEEL:1}${WHEEL:0:1}
}

docker run \
    -d \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw,shared \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    gcr.io/google_containers/hyperkube:v1.7.10 \
    sh "/rootfs/$PWD/etc/kube/internal.sh"
echo waiting for kubectl version to pass...
until kubectl version 2>/dev/null >/dev/null; do spin; sleep 5; done
echo kubectl version passed
