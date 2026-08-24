
FROM composer:2.7 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
# Ajout de --ignore-platform-reqs pour ignorer l'absence d'ext-mongodb lors du download
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist --ignore-platform-reqs


FROM php:8.3-fpm-alpine
WORKDIR /var/www/html


RUN apk add --no-cache libpng-dev libzip-dev zip unzip postgresql-dev $PHPIZE_DEPS \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql gd zip

COPY . .
COPY --from=vendor /app/vendor ./vendor

RUN composer dump-autoload --optimize --ignore-platform-reqs \
    && chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
