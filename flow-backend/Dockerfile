FROM composer:2.7 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

FROM php:8.3-fpm-alpine
WORKDIR /var/www/html

RUN apk add --no-cache libpng-dev libzip-dev zip unzip postgresql-dev \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql gd zip

COPY . .
COPY --from=vendor /app/vendor ./vendor

RUN composer dump-autoload --optimize \
    && chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
