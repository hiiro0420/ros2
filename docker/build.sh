#!/bin/bash

BUILD_DIR=$(dirname $(readlink -f $0))/src
IMAGE_NAME="ros2:humble"
USER_NAME="ros2"

docker build \
    -t ${IMAGE_NAME} \
    --build-arg UID=$(id -u) \
    --build-arg USER_NAME=${USER_NAME} \
    --build-arg HOSTNAME=$(hostname) \
    ${BUILD_DIR}