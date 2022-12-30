ARG OLS_VERSION
ARG PHP_VERSION
ARG PHP_MAJOR_VERSION
ARG PHP_MINOR_VERSION

FROM arm64v8/wordpress:cli-php$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION AS wp-cli

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

ENV OLS_VERSION=${OLS_VERSION}
ENV PHP_VERSION=${PHP_VERSION}
ENV PHP_MAJOR_VERSION=${PHP_MAJOR_VERSION}
ENV PHP_MINOR_VERSION=${PHP_MINOR_VERSION}

COPY *.sh /build/

# Build structure for small images.
# References:
#     - https://www.dajobe.org/blog/2015/04/18/making-debian-docker-images-smaller/
#     - https://github.com/dajobe/docker-nghttp2
RUN /build/prepare-build.sh && \
    /build/prepare-php.sh && \
    cd /build/php-$PHP_VERSION && make -j3 && make install && \
    /build/prepare-ols.sh && \
    cd /build/openlitespeed-$OLS_VERSION && ./build.sh && ./install.sh && \
    echo 'cloud-docker' > /usr/local/lsws/PLAT && \
    /build/prepare-ols-admin_php.sh && \
    cd /usr/local/lsws/phpbuild/php-$PHP_VERSION && make -j3 && \
    /build/config-ols-admin_php.sh && \
    /build/config-ols.sh && \
    /build/prepare-acme.sh && \
    cd / && /build/cleanup-build-env.sh && rm -rf /build

COPY --from=wp-cli ["/usr/local/bin/wp", "/usr/local/bin/wp"]

EXPOSE 7080
ENV PATH="/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin"

COPY docker.conf /usr/local/lsws/conf/templates/docker.conf
COPY httpd_config.xml /usr/local/lsws/conf/httpd_config.xml
COPY htpasswd /usr/local/lsws/admin/conf/htpasswd

RUN chown 999:999 /usr/local/lsws/conf -R
RUN cp -RP /usr/local/lsws/conf/ /usr/local/lsws/.conf/
RUN cp -RP /usr/local/lsws/admin/conf /usr/local/lsws/admin/.conf/
RUN ln -sf /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp${PHP_MAJOR_VERSION}.${PHP_MINOR_VERSION} /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp
RUN ln -sf /usr/local/lsws/lsphp${PHP_MAJOR_VERSION}${PHP_MINOR_VERSION}/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp8
RUN ln -sf /usr/local/lsws/fcgi-bin/lsphp8 /usr/local/lsws/fcgi-bin/lsphp

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/vhosts/

