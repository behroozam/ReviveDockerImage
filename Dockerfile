FROM alpine
MAINTAINER behroozam <b.hasanbg@gmail.com>

WORKDIR /var/www/html

RUN apk --update upgrade && apk update && apk add curl ca-certificates && update-ca-certificates --fresh && apk add openssl
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories 
RUN apk --update add \
        nginx \
        gzip \
        git \
        php7 \
        php7-dom \
        php7-ctype \
        php7-curl \
        php7-fpm \
        php7-gd \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqli \
        php7-mysqlnd \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        php7-posix \
        php7-session \
        php7-xml \
        php7-iconv \
        php7-phar \
        php7-openssl \
        php7-zip \
        php7-zlib \
    && rm -rf /var/cache/apk/*

RUN wget -qO- https://download.revive-adserver.com/revive-adserver-4.1.4.tar.gz | tar xz --strip 1 \
    && chown -R nobody:nobody . \
    && rm -rf /var/cache/apk/*
RUN rm -rf composer.lock
COPY composer.phar .
RUN php composer.phar install
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /run/nginx && chown -R nobody:nobody /var/tmp/nginx
COPY php/php.ini /etc/php7/php.ini
COPY php/www.conf /etc/php7/php-fpm.d/www.conf
EXPOSE 80
CMD php-fpm7 && nginx -g 'daemon off;'
