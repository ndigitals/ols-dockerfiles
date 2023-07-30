# This file intended to be sourced

# . /build/config-build-env.sh

# Prevent initramfs updates from trying to run grub and lilo.
export INITRD=no
export DEBIAN_FRONTEND=noninteractive

MINIMAL_APT_GET_ARGS='-y --no-install-recommends --allow-downgrades'

# File containing original installed packages
PACKAGES_INSTALLED_LOG="/tmp/packages.lst"

## Run time dependencies ##
RUN_PACKAGES="cron tzdata mariadb-client openssl=1.1.1n-0+deb11u4 libssl1.1 libgssapi-krb5-2 libkrb5-3 libexpat1 libxml2 libargon2-1 libenchant-2-2 libpng16-16 libwebp6 libjpeg62-turbo libxpm4 libfreetype6 libonig5 libsodium23 libxslt1.1 libzip4 libzstd1 liblz4-1 libcurl4 libcurlpp0 imagemagick libc-client2007e libmemcached11 libdbd-freetds freetds-bin procps libatomic1 net-tools less libjpeg-turbo-progs optipng gifsicle zip unzip libyajl2 libpcre2-posix3 liblmdb0 libgeoip1 ruby-full gnupg2 nodejs yarn libmodsecurity3 modsecurity-crs liblua5.3-0"

## Build time dependencies ##

# git is needed for git clone; not building
# alternate would be to download a release tarball with curl or wget
BUILD_PACKAGES="git curl wget"

# Core list from docs
BUILD_PACKAGES="$BUILD_PACKAGES pkg-config"

# OLS build required packages
BUILD_PACKAGES="$BUILD_PACKAGES cmake g++ libgeoip-dev liblmdb-dev libyajl-dev libmodsecurity-dev liblua5.3-dev"

# PHP building required packages
BUILD_PACKAGES="$BUILD_PACKAGES build-essential libdb5.3-dev krb5-multidev libkrb5-dev bison autoconf automake libtool re2c flex libxml2-dev libbz2-dev libcurlpp-dev libssl-dev=1.1.1n-0+deb11u4 libcurl4-openssl-dev libexpat1-dev libjpeg-dev libfreetype6-dev libgmp3-dev libpng-dev libxpm-dev libc-client2007e-dev libenchant-2-dev libsasl2-dev libc-client2007e-dev libldap2-dev libldb-dev libmcrypt-dev libmhash-dev freetds-dev zlib1g-dev libpq-dev libmariadb-dev-compat libmariadb-dev libncurses5-dev libpcre2-dev unixodbc-dev libsqlite3-dev libaspell-dev libreadline6-dev librecode-dev libsnmp-dev libtidy-dev libxslt-dev libonig-dev libzip-dev libwebp-dev freetds-dev libpspell-dev libedit-dev libsodium-dev libargon2-dev libvarnishapi-dev libmagickwand-dev libmagickcore-dev libmemcached-dev libzstd-dev liblz4-dev libyaml-dev libffi-dev"

# apt-get remove --allow-remove-essential enters an infinite loop of
# pam errors with this package
#  login: because it depends on libpam*
PACKAGES_REMOVE_SKIP_REGEX='(libpam|login)'

# Setup OpenLiteSpeed home directory.
LSWS_HOME=/usr/local/lsws
