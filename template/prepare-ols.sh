#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit 

# carefully, it's import to export PKG_CONFIG_PATH to tell the pkg-config the info about yajl
export PKG_CONFIG_PATH=/usr/local/share/pkgconfig:PKG_CONFIG_PATH

# Download and prepare OpenLiteSpeed source.
# wget https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION.src.tgz && \
# 	tar xzf openlitespeed-$OLS_VERSION.src.tgz

# Add OpenLiteSpeed package repositories.
wget -O /etc/apt/trusted.gpg.d/lst_debian_repo.gpg http://rpms.litespeedtech.com/debian/lst_debian_repo.gpg
wget -O /etc/apt/trusted.gpg.d/lst_repo.gpg http://rpms.litespeedtech.com/debian/lst_repo.gpg
echo "deb http://rpms.litespeedtech.com/debian/ bullseye main" > /etc/apt/sources.list.d/lst_debian_repo.list
echo "#deb http://rpms.litespeedtech.com/edge/debian/ bullseye main" >> /etc/apt/sources.list.d/lst_debian_repo.list
echo 'LiteSpeed repository has been setup!'

apt-get update -y

