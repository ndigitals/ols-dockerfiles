ARG OLS_VERSION
ARG PHP_VERSION
ARG PHP_MAJOR_VERSION
ARG PHP_MINOR_VERSION

FROM arm64v8/wordpress:cli-php$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION as wp-cli

FROM arm64v8/ubuntu:22.04

LABEL org.opencontainers.image.url=https://github.com/ndigitals/ols-dockerfiles
LABEL org.opencontainers.image.documentation=https://github.com/ndigitals/ols-dockerfiles/wiki
LABEL org.opencontainers.image.source=https://github.com/ndigitals/ols-dockerfiles
LABEL org.opencontainers.image.vendor="Nolte Digital Solutions"
LABEL org.opencontainers.image.licenses=MIT

ENV PHP_VERSION=$PHP_VERSION

RUN WORK_DIR=`pwd`

# Install require build packages.
RUN apt-get update && \
    apt-get install -y \
    wget curl cron tzdata mysql-client \
    build-essential pkg-config openssl libssl-dev openssl-blacklist openssl-blacklist-extra \
    bison autoconf automake libtool re2c flex libxml2-dev libssl-dev libbz2-dev libcurl4-openssl-dev \
    libdb5.1-dev libjpeg-dev libpng12-dev libXpm-dev libfreetype6-dev libt1-dev libgmp3-dev \
    libc-client2007e-dev libldap2-dev libmcrypt-dev libmhash-dev freetds-dev zlib1g-dev \
    libmysqlclient-dev libncurses5-dev libpcre3-dev unixODBC-dev libsqlite0-dev libaspell-dev \
    libreadline6-dev librecode-dev libsnmp-dev libtidy-dev libxslt-dev libt1-dev

# Build LSPHP from source.
RUN wget https://www.php.net/distributions/php-$PHP_VERSION.tar.gz && \
    tar xzf php-$PHP_VERSION.tar.gz && cd php-$PHP_VERSION && \
    ./configure  "--prefix=/usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}" '--with-libdir=lib64' '--with-zlib' '--with-gd' '--enable-shmop' '--enable-sockets' '--enable-sysvsem' '--enable-sysvshm' '--with-curl' '--with-openssl' '--with-gettext' '--with-mcrypt' '--enable-mbstring=all' '--enable-mbregex' '--with-png-dir=/usr' '--with-jpeg-dir=/usr' '--with-kerberos' '--enable-ftp' '--with-imap=/usr' '--with-imap-ssl' '--with-mysql=/usr' '--with-mysqli=/usr/bin/mysql_config' '--enable-pcntl' '--with-freetype-dir=/usr' '--with-pdo-mysql=/usr' '--with-litespeed' && \
    make && make install && cd $WORK_DIR && rm -rf ./php-$PHP_VERSION && rm ./php-$PHP_VERSION.tar.gz

# Build OpenLiteSpeed from source.
RUN wget https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION.src.tgz && \
    tar xzf openlitespeed-$OLS_VERSION.src.tgz && cd openlitespeed-$OLS_VERSION && \
    ./build.sh && ./install.sh && cd $WORK_DIR && \
    echo 'cloud-docker' > /usr/local/lsws/PLAT && rm -rf ./openlitespeed-$OLS_VERSION && rm ./openlitespeed-$OLS_VERSION.tgz

RUN wget -O /usr/local/lsws/admin/misc/lsup.sh \
    https://raw.githubusercontent.com/litespeedtech/openlitespeed/master/dist/admin/misc/lsup.sh && \
    chmod +x /usr/local/lsws/admin/misc/lsup.sh

COPY --from=wp-cli ["/usr/local/bin/wp", "/usr/local/bin/wp"]

RUN ln -s /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/php /usr/bin/php

RUN wget -O -  https://get.acme.sh | sh

EXPOSE 7080
ENV PATH="/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin"

ADD docker.conf /usr/local/lsws/conf/templates/docker.conf
ADD setup_docker.sh /usr/local/lsws/bin/setup_docker.sh
ADD httpd_config.xml /usr/local/lsws/conf/httpd_config.xml
ADD htpasswd /usr/local/lsws/admin/conf/htpasswd

RUN /usr/local/lsws/bin/setup_docker.sh && rm /usr/local/lsws/bin/setup_docker.sh
RUN chown 999:999 /usr/local/lsws/conf -R
RUN cp -RP /usr/local/lsws/conf/ /usr/local/lsws/.conf/
RUN cp -RP /usr/local/lsws/admin/conf /usr/local/lsws/admin/.conf/
RUN ln -sf /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp8
RUN ln -sf /usr/local/lsws/fcgi-bin/lsphp8 /usr/local/lsws/fcgi-bin/lsphp

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/vhosts/
