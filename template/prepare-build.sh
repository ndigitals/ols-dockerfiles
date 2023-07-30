#!/bin/bash -x

. /build/config-build-env.sh

apt-get update -y
apt install curl ca-certificates -y

# Prepare to install Node 16.
curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Prepare to install Yarn.
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Add snapshots repository to install OpenSSL 1.1.1o & WebP6 libraries.
echo "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/20230528T210109Z/ bullseye main" | tee /etc/apt/sources.list.d/snapshots.2023.list

apt-get update -y

dpkg --get-selections | awk '{print $1}' | sort > "$PACKAGES_INSTALLED_LOG"
echo "Installed packages at start"
cat "$PACKAGES_INSTALLED_LOG"

apt-get install $MINIMAL_APT_GET_ARGS $BUILD_PACKAGES $RUN_PACKAGES

