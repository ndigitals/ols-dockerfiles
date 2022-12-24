#!/bin/bash -x

. /build/config-build-env.sh

apt-get update -y

dpkg --get-selections | awk '{print $1}' | sort > "$PACKAGES_INSTALLED_LOG"
echo "Installed packages at start"
cat "$PACKAGES_INSTALLED_LOG"

apt-get install $MINIMAL_APT_GET_ARGS $BUILD_PACKAGES $RUN_PACKAGES

