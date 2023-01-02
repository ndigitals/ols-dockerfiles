#!/bin/bash -x

. /build/config-build-env.sh

cd $LSWS_HOME/phpbuild || exit

# Copy expat libraries for PHP OLS admin build.
cp /usr/lib/aarch64-linux-gnu/libexpat* /lib/

# Build admin_php from source.
wget https://www.php.net/distributions/php-$OLS_ADMIN_PHP_VERSION.tar.gz && \
	tar xzf php-$OLS_ADMIN_PHP_VERSION.tar.gz && cd php-$OLS_ADMIN_PHP_VERSION && \
	./configure '--prefix=/tmp' '--disable-all' '--enable-litespeed' '--enable-session' '--enable-posix' '--with-libxml' '--with-expat' '--with-zlib' '--enable-sockets' '--enable-bcmath' '--enable-json'
