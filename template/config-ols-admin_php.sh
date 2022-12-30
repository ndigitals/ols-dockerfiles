#!/bin/bash -x

. /build/config-build-env.sh

cd $LSWS_HOME/admin/fcgi-bin || exit

# Copy admin_php to destination and setup for execution.
cp $LSWS_HOME/phpbuild/php-$OLS_ADMIN_PHP_VERSION/sapi/litespeed/php admin_php-${OLS_ADMIN_PHP_MAJOR_VERSION}
chmod a+rx admin_php-${OLS_ADMIN_PHP_MAJOR_VERSION}
ln -sf admin_php-${OLS_ADMIN_PHP_MAJOR_VERSION} admin_php
