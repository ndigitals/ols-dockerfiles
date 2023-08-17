#!/bin/bash -x

. /build/config-build-env.sh

apt-get update -y
apt-get install $MINIMAL_APT_GET_ARGS $BUILD_PACKAGES

