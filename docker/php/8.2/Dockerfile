FROM php:8.2-fpm

ARG UID=10004
ARG GID=10004

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    libzip-dev \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include/ \
    && docker-php-ext-install pdo pdo_mysql mysqli zip pdo_pgsql pcntl opcache gd \
    && pecl install redis \
    && docker-php-ext-enable redis

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN adduser -D -H -u ${UID} -s /bin/bash www-data -G www-data
RUN mkdir -p /home/www-data && chown $UID:$GID /home/www-data -R

# Set working directory
WORKDIR /var/www/html

# Change current user to www
USER $UID

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
