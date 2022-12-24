#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit 

wget -O -  https://get.acme.sh | sh

