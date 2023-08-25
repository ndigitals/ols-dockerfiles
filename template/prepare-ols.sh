#!/bin/bash -x

. /build/config-build-env.sh

cd /build || exit 

# carefully, it's import to export PKG_CONFIG_PATH to tell the pkg-config the info about yajl
export PKG_CONFIG_PATH=/usr/local/share/pkgconfig:PKG_CONFIG_PATH

# Configure OpenLiteSpeed binary repository.
REPO_OS_CODENAME=$(cat /etc/os-release |  grep '^VERSION_CODENAME=' | head -n1 | awk -F '=' '{print $2}' | tr -d '"')

wget -O /etc/apt/trusted.gpg.d/lst_debian_repo.gpg http://rpms.litespeedtech.com/debian/lst_debian_repo.gpg && \
  wget -O /etc/apt/trusted.gpg.d/lst_repo.gpg http://rpms.litespeedtech.com/debian/lst_repo.gpg && \
  echo "deb http://rpms.litespeedtech.com/debian/ ${REPO_OS_CODENAME} main" > /etc/apt/sources.list.d/lst_debian_repo.list && \
  echo "#deb http://rpms.litespeedtech.com/edge/debian/ ${REPO_OS_CODENAME} main" >> /etc/apt/sources.list.d/lst_debian_repo.list && \
  apt-get update -y && \
  apt-get install $MINIMAL_APT_GET_ARGS openlitespeed=${OLS_VERSION}* ols-modsecurity

dpkg --get-selections | awk '{print $1}' | sort > "$PACKAGES_INSTALLED_LOG"
echo "Installed packages at start"
cat "$PACKAGES_INSTALLED_LOG"

