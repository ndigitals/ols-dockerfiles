ARG OLS_VERSION
ARG PHP_VERSION
ARG PHP_MAJOR_VERSION
ARG PHP_MINOR_VERSION

FROM arm64v8/wordpress:cli-php$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION as wp-cli

FROM arm64v8/debian:11-slim

LABEL org.opencontainers.image.url=https://github.com/ndigitals/ols-dockerfiles
LABEL org.opencontainers.image.documentation=https://github.com/ndigitals/ols-dockerfiles/wiki
LABEL org.opencontainers.image.source=https://github.com/ndigitals/ols-dockerfiles
LABEL org.opencontainers.image.vendor="Nolte Digital Solutions"
LABEL org.opencontainers.image.licenses=MIT

ARG OLS_VERSION
ARG PHP_VERSION
ARG PHP_MAJOR_VERSION
ARG PHP_MINOR_VERSION
ENV PHP_VERSION=${PHP_VERSION}

ARG BUILD_PACKAGES="build-essential libssl-dev libdb5.3-dev krb5-multidev libkrb5-dev bison autoconf automake libtool re2c flex libxml2-dev libbz2-dev libcurl4-openssl-dev libexpat1-dev libjpeg-dev libfreetype6-dev libgmp3-dev libpng-dev libxpm-dev libc-client2007e-dev libenchant-2-dev libsasl2-dev libc-client2007e-dev libldap2-dev libldb-dev libmcrypt-dev libmhash-dev freetds-dev zlib1g-dev libpq-dev libmariadb-dev-compat libmariadb-dev libncurses5-dev libpcre3-dev unixodbc-dev libsqlite3-dev libaspell-dev libreadline6-dev librecode-dev libsnmp-dev libtidy-dev libxslt-dev libonig-dev libzip-dev libwebp-dev freetds-dev libpspell-dev libedit-dev libsodium-dev libargon2-dev libvarnishapi-dev"
ENV BUILD_PACKAGES=${BUILD_PACKAGES}

# Install require build packages.
RUN apt-get update && \
    apt-get install -y ${BUILD_PACKAGES} wget curl cron tzdata mariadb-client \
    pkg-config openssl libgssapi-krb5-2 libkrb5-3 libexpat1 libc-client2007e libdbd-freetds freetds-bin \


# Fix FreeTDS missing libraries.
RUN ln -s /usr/lib/aarch64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a && \
    ln -s /usr/lib/aarch64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so

# Build LSPHP from source.
RUN cd /tmp && wget https://www.php.net/distributions/php-$PHP_VERSION.tar.gz && \
    tar xzf php-$PHP_VERSION.tar.gz && cd php-$PHP_VERSION && \
    ./configure  "--prefix=/usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}" '--enable-cgi' '--enable-cli' '--enable-phpdbg=no' '--enable-litespeed' "--with-config-file-path=/usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/litespeed/" "--with-config-file-scan-dir=/usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/etc/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}/mods-available/" '--build=aarch64-linux-gnu' '--host=aarch64-linux-gnu' '--libdir=${prefix}/lib/php' '--libexecdir=${prefix}/lib/php' "--datadir=${prefix}/share/php/${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}" "--program-suffix=${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION}" '--disable-all' '--disable-debug' '--disable-rpath' '--disable-static' '--with-pic' '--with-layout=GNU' '--without-pear' '--enable-bcmath' '--enable-calendar' '--enable-dom' '--with-enchant' '--enable-exif' '--with-gettext' '--with-gmp' '--enable-ftp' '--with-iconv' '--enable-mbregex' '--enable-mbstring' '--enable-mysqlnd-compression-support' '--with-zlib' '--with-openssl=yes' '--with-libedit' '--with-libxml' '--with-bz2' '--enable-soap' '--enable-sockets' '--with-xsl' '--with-mhash=yes' '--enable-sysvmsg' '--enable-sysvsem' '--enable-sysvshm' '--with-zip' '--with-sodium' '--with-password-argon2' '--enable-gd' '--with-jpeg' '--with-xpm' '--with-webp' '--with-freetype' '--with-mysql-sock=/var/run/mysqld/mysqld.sock' '--disable-dtrace' '--enable-pdo' '--enable-mysqlnd' '--enable-pcntl' '--with-sqlite3=shared,/usr' '--with-pdo-sqlite=shared,/usr' '--with-pdo-dblib=shared,/usr' '--with-ldap=shared,/usr' '--with-ldap-sasl=/usr' '--enable-intl=shared' '--with-snmp=shared,/usr' '--with-pgsql=shared,/usr' '--with-pdo-pgsql=shared,/usr' '--enable-huge-code-pages' '--with-imap=shared,/usr' '--with-kerberos' '--with-imap-ssl=yes' '--with-mysqli=shared,mysqlnd' '--with-pdo-mysql=shared,mysqlnd' '--with-tidy=shared,/usr' '--with-pspell=shared,/usr' '--with-curl=shared,/usr' && \
    make -j3 && make install && cd /tmp && rm -rf ./php-$PHP_VERSION && rm ./php-$PHP_VERSION.tar.gz && cd /

# Build OpenLiteSpeed from source.
RUN cd /tmp && wget https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION.src.tgz && \
    tar xzf openlitespeed-$OLS_VERSION.src.tgz && cd openlitespeed-$OLS_VERSION && \
    ./build.sh && ./install.sh && cd /tmp && \
    echo 'cloud-docker' > /usr/local/lsws/PLAT && rm -rf ./openlitespeed-$OLS_VERSION && rm ./openlitespeed-$OLS_VERSION.src.tgz && cd /

RUN wget -O /usr/local/lsws/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh && \
    chmod +x /usr/local/lsws/admin/misc/lsup.sh

COPY --from=wp-cli ["/usr/local/bin/wp", "/usr/local/bin/wp"]

RUN ln -s /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php /usr/bin/php

RUN wget -O -  https://get.acme.sh | sh

EXPOSE 7080
ENV PATH="/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin"

COPY docker.conf /usr/local/lsws/conf/templates/docker.conf
COPY setup_docker.sh /usr/local/lsws/bin/setup_docker.sh
COPY httpd_config.xml /usr/local/lsws/conf/httpd_config.xml
COPY htpasswd /usr/local/lsws/admin/conf/htpasswd

RUN /usr/local/lsws/bin/setup_docker.sh && rm /usr/local/lsws/bin/setup_docker.sh
RUN chown 999:999 /usr/local/lsws/conf -R
RUN cp -RP /usr/local/lsws/conf/ /usr/local/lsws/.conf/
RUN cp -RP /usr/local/lsws/admin/conf /usr/local/lsws/admin/.conf/
RUN ln -sf /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp8
RUN ln -sf /usr/local/lsws/fcgi-bin/lsphp8 /usr/local/lsws/fcgi-bin/lsphp

# Cleanup the system to keep things lean.
# https://www.dajobe.org/blog/2015/04/18/making-debian-docker-images-smaller/
RUN AUTO_ADDED_PACKAGES=`apt-mark showauto`
RUN apt-get remove --purge -y --force-yes ${BUILD_PACKAGES} $AUTO_ADDED_PACKAGES

RUN apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y & rm -rf /tmp/third-party

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/vhosts/
