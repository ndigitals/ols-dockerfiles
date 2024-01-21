#!/bin/bash -x

. /build/config-build-env.sh

apt-get update -y
apt-get install $MINIMAL_APT_GET_ARGS $SETUP_PACKAGES

# Prepare to install Node.
curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -

# Prepare to install Yarn.
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt-get update -y
apt-get install $MINIMAL_APT_GET_ARGS $RUN_PACKAGES

