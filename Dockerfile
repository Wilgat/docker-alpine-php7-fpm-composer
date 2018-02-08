FROM alpine:edge

MAINTAINER Cloudgen Wong <cloudgen.wong@clearomni.com>

ENV TIMEZONE            Asia/Hong_Kong
ENV PHP_MEMORY_LIMIT    512M
ENV MAX_UPLOAD          50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        100M

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
  >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache wget git openssh && \
  apk add --update tzdata && \
  cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone && \
  apk add --update \
    php7-mcrypt \
    php7-soap \
    php7-openssl \
    php7-gmp \
    php7-pdo_odbc \
    php7-json \
    php7-dom \
    php7-pdo \
    php7-zip \
    php7-mysqli \
    php7-sqlite3 \
    php7-pdo_pgsql \
    php7-bcmath \
    php7-gd \
    php7-odbc \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-gettext \
    php7-xmlreader \
    php7-xmlrpc \
    php7-bz2 \
    php7-iconv \
    php7-pdo_dblib \
    php7-curl \
    php7-ctype \
    php7-fpm
RUN apk add --no-cache \
    php5-cli  \
    php5-json \
    php5-phar \
    php5-openssl \
    php5-zlib && \
  sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf && \
  sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php7/php-fpm.d/www.conf && \
  sed -i "s|;*listen\s*=\s*/||g" /etc/php7/php-fpm.d/www.conf && \
  sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini && \
  sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && \
  sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php7/php.ini && \
  sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && \
  sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && \
  sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php7/php.ini && \
  mkdir /var/www && \
	apk del tzdata && \
  rm -rf /var/cache/apk/*
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/c1ad3667731e9c5c1a21e5835c7e6a7eedc2e1fe/web/installer \
   -O - -q | php5 -- --quiet
RUN ln /usr/bin/php5 /usr/bin/php
RUN mv composer.phar /usr/bin/composer
WORKDIR /var/www
VOLUME ["/var/www"]
EXPOSE 9000
ENTRYPOINT ["/usr/sbin/php-fpm7"]
