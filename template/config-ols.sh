#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit

wget -O $LSWS_HOME/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh

chmod +x $LSWS_HOME/admin/misc/lsup.sh

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

# Make sure that the fcgi lsphp is properly symlinked after the OLD build.
ln -sf $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} $LSWS_HOME/fcgi-bin/lsphp8
ln -sf $LSWS_HOME/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} $LSWS_HOME/fcgi-bin/lsphp

mkdir -p /var/www/vhosts/localhost/{html,logs,certs}
chown 1000:1000 /var/www/vhosts/localhost/ -R
