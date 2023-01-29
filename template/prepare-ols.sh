#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit 

# carefully, it's import to export PKG_CONFIG_PATH to tell the pkg-config the info about yajl
export PKG_CONFIG_PATH=/usr/local/share/pkgconfig:PKG_CONFIG_PATH

# Download and prepare OpenLiteSpeed source.
wget https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION.src.tgz && \
	tar xzf openlitespeed-$OLS_VERSION.src.tgz

