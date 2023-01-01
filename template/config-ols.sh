#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit 

wget -O $LSWS_HOME/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh

chmod +x $LSWS_HOME/admin/misc/lsup.sh

ln -s $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} /usr/bin/php
ln -s $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} /usr/local/bin/lsphp

# Get PEAR/PECL to install modules.
cd $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin
wget http://pear.php.net/go-pear.phar
./lsphp go-pear.phar

cd /build || exit 

# Install missing PECL PHP modules.
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install redis
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install imagick
$LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/pecl install memcached

echo "listener HTTP {
  address                 *:80
  secure                  0
}

listener HTTPS {
  address                 *:443
  secure                  1
  keyFile                 /usr/local/lsws/admin/conf/webadmin.key
  certFile                /usr/local/lsws/admin/conf/webadmin.crt
}

vhTemplate docker {
  templateFile            conf/templates/docker.conf
  listeners               HTTP, HTTPS
  note                    docker

  member localhost {
    vhDomain              localhost, *
  }
}

" >> $LSWS_HOME/conf/httpd_config.conf

mkdir -p /var/www/vhosts/localhost/{html,logs,certs}
chown 1000:1000 /var/www/vhosts/localhost/ -R