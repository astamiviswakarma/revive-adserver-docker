FROM php:7-fpm-alpine

WORKDIR /var/www/html

RUN apk update
RUN apk add -U gzip \
               nginx \
               tar

RUN docker-php-ext-install curl gd json mysql opcache openssl pgsql phar xml zlib

RUN wget -O- https://download.revive-adserver.com/revive-adserver-4.2.1.tar.gz | tar xz --strip 1

RUN chown -R nobody:nobody . \
    && rm -rf /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD php-fpm && nginx -g 'daemon off;'