FROM php:7-fpm-alpine

WORKDIR /var/www/html

RUN apk update
RUN apk add -U gzip \
               nginx \
               curl-dev \
               libpng-dev \
               postgresql-dev \
               libxml2-dev \
               libzip-dev \
               supervisor \
               tar

RUN docker-php-ext-install curl gd json mysqli pdo pdo_mysql pdo_pgsql opcache pgsql phar simplexml xml zip

RUN wget -O- https://download.revive-adserver.com/revive-adserver-4.2.1.tar.gz | tar xz --strip 1

RUN chown -R nobody:nobody . \
    && rm -rf /var/cache/apk/*
RUN chmod -R a+w /var/www/html/var \
    /var/www/html/plugins \
    /var/www/html/www/admin/plugins \
    /var/www/html/www/images

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/nginx.supervisor.conf /etc/supervisor/conf.d/nginx.conf
COPY conf/phpfpm.supervisor.conf /etc/supervisor/conf.d/php-fpm.conf

EXPOSE 80

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]