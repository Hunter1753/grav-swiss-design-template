FROM php:8.3-apache

# Enable Apache URL rewriting for Grav
RUN a2enmod rewrite

# Install required PHP extensions for Grav (GD, Zip, OPcache, YAML)
RUN apt-get update && apt-get install -y \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libyaml-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip opcache \
    && pecl install yaml && docker-php-ext-enable yaml

WORKDIR /var/www/html

# Download the latest Grav + Admin core
RUN curl -o grav.zip -SL https://getgrav.org/download/core/grav-admin/latest \
    && unzip grav.zip \
    && rm grav.zip \
    && cp -a grav-admin/. . \
    && rm -rf grav-admin

# Set correct permissions for the web server
RUN chown -R www-data:www-data /var/www/html
