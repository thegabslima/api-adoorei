FROM php:8.1
COPY . /app
WORKDIR /app

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . .

RUN composer dump-autoload --optimize

RUN chown -R www-data:www-data /app/storage

EXPOSE 80

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]

