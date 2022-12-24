#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit 

# Build OpenLiteSpeed from source.
wget https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION.src.tgz && \
	tar xzf openlitespeed-$OLS_VERSION.src.tgz && cd openlitespeed-$OLS_VERSION

