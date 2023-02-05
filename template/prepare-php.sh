#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit

# Fix FreeTDS missing libraries.
ln -s /usr/lib/aarch64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a && \
ln -s /usr/lib/aarch64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so

# Build LSPHP from source.
wget https://www.php.net/distributions/php-$PHP_VERSION.tar.gz && \
	tar xzf php-$PHP_VERSION.tar.gz && cd php-$PHP_VERSION && \
	./configure "--prefix=/usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}" '--enable-cgi' '--enable-cli' '--enable-phpdbg=no' '--enable-litespeed' "--with-config-file-path=/usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/litespeed/" "--with-config-file-scan-dir=/usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/mods-available/" '--build=aarch64-linux-gnu' '--host=aarch64-linux-gnu' '--libdir=${prefix}/lib/php' '--libexecdir=${prefix}/lib/php' "--datadir=${prefix}/share/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}" "--program-suffix=${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}" '--disable-debug' '--disable-rpath' '--disable-static' '--with-pic' '--with-layout=GNU' '--with-pear' '--enable-bcmath' '--enable-calendar' '--enable-dom' '--with-enchant' '--enable-exif' '--with-gettext' '--with-gmp' '--enable-ftp' '--with-iconv' '--enable-mbregex' '--enable-mbstring' '--enable-mysqlnd-compression-support' '--with-zlib' '--with-openssl=yes' '--with-libedit' '--with-libxml' '--enable-xml' '--with-bz2' '--enable-soap' '--enable-sockets' '--with-xsl' '--with-mhash=yes' '--enable-sysvmsg' '--enable-sysvsem' '--enable-sysvshm' '--with-zip' '--with-sodium' '--with-password-argon2' '--enable-gd' '--with-jpeg' '--with-xpm' '--with-webp' '--with-freetype' '--with-mysql-sock=/var/run/mysqld/mysqld.sock' '--disable-dtrace' '--enable-pdo' '--enable-mysqlnd' '--enable-pcntl' '--with-sqlite3=shared,/usr' '--with-pdo-sqlite=shared,/usr' '--with-pdo-dblib=shared,/usr' '--with-ldap=shared,/usr' '--with-ldap-sasl=/usr' '--enable-intl=shared' '--with-snmp=shared,/usr' '--with-pgsql=shared,/usr' '--with-pdo-pgsql=shared,/usr' '--enable-huge-code-pages' '--with-imap=shared,/usr' '--with-kerberos' '--with-imap-ssl=yes' '--with-mysqli=shared,mysqlnd' '--with-pdo-mysql=shared,mysqlnd' '--with-tidy=shared,/usr' '--with-pspell=shared,/usr' '--with-curl=shared,/usr' '--enable-phar' '--enable-opcache' '--enable-opcache-file' '--enable-session' '--enable-tokenizer' '--enable-filter' '--enable-fileinfo' '--enable-simplexml' '--enable-xmlreader' '--enable-xmlwriter' '--with-xmlrpc'
