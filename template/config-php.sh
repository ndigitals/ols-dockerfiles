#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit

ln -sf $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} /usr/bin/php
ln -sf $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php
ln -sf $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} /usr/local/bin/lsphp
ln -sf $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp

# Install missing PECL PHP modules.
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install igbinary
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install msgpack
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install lzf
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install zstd
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install imagick
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install xmlrpc
yes "yes" | $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install redis
printf "\n\n\nyes\nyes\nyes\n\nyes\nyes\n" | $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install memcached
