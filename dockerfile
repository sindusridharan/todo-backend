# Use the official PHP image as base
FROM php:7.4-fpm

#Copy custom php.ini file
COPY custom_php.ini /usr/local/etc/php/php.ini

# Set the working directory inside the container
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libpq-dev \
        zip \
        nano \
        unzip \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install

# Expose port 8000 to the outside world
EXPOSE 8000

# Command to run the PHP built-in server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
