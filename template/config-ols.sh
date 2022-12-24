#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit 

wget -O /usr/local/lsws/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh

chmod +x /usr/local/lsws/admin/misc/lsup.sh

ln -s /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php /usr/bin/php

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

" >> /usr/local/lsws/conf/httpd_config.conf

mkdir -p /var/www/vhosts/localhost/{html,logs,certs}
chown 1000:1000 /var/www/vhosts/localhost/ -R
