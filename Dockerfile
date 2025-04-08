# Use PHP 8.3 Alpine with FPM (FastCGI Process Manager)
FROM php:8.3-fpm-alpine

# Install Nginx, cron, and other necessary dependencies
RUN apk update && apk add --no-cache nginx git unzip curl zip libzip-dev \
    && apk add --no-cache dcron \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer (from the latest Composer image)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the Nginx and PHP configuration files
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY php/php.ini /usr/local/etc/php/php.ini

# Set the working directory
WORKDIR /var/www/html

# Expose port 80 for HTTP
EXPOSE 80

# Add crontab file (optional)
# COPY cronjobs /etc/crontabs/root

# Start cron, Nginx, and PHP-FPM
CMD crond && service nginx start && php-fpm
