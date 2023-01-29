#!/bin/bash -x

. /build/config-build-env.sh

apt-get update -y
apt install curl -y

# Prepare to install Node 16.
curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Prepare to install Yarn.
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt-get update -y

dpkg --get-selections | awk '{print $1}' | sort > "$PACKAGES_INSTALLED_LOG"
echo "Installed packages at start"
cat "$PACKAGES_INSTALLED_LOG"

apt-get install $MINIMAL_APT_GET_ARGS $BUILD_PACKAGES $RUN_PACKAGES

# https://github.com/SpiderLabs/ModSecurity/issues/804#issuecomment-246158487
#cd /build || exit

# Download and prepare YAJL source.
#wget https://github.com/lloyd/yajl/archive/refs/tags/2.1.0.tar.gz -O yajl-2.1.0.tar.gz && \
#	tar xzf yajl-2.1.0.tar.gz && cd yajl-2.1.0 && \
#	./configure

