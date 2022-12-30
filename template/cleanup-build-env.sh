#!/bin/bash -x

. /build/config-build-env.sh

# Remove auto added packages beyond those from base install
tmp=$(mktemp)
dpkg --get-selections | awk '{print $1}' | sort > "$tmp"
echo "Installed packages at end"
cat "$tmp"
PACKAGES_TO_REMOVE=$(comm -23 "$tmp" "$PACKAGES_INSTALLED_LOG")
rm -f "$tmp"

apt-get remove --purge -y $PACKAGES_TO_REMOVE

# Install the run-time dependencies
apt-get install $MINIMAL_APT_GET_ARGS $RUN_PACKAGES

rm -rf /tmp/* /var/tmp/* $LSWS_HOME/phpbuild

apt-get clean
rm -rf /var/lib/apt/lists/*
