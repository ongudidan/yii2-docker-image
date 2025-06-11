# Start from a base Alpine image (possibly php:8.3-fpm-alpine or similar)
FROM php:8.3-fpm-alpine

LABEL maintainer="CrackIT <admin@crackit.co.ke>"

# Set environment variables
ENV PHPIZE_DEPS="autoconf dpkg-dev dpkg" \
    PHP_INI_DIR="/usr/local/etc/php" \
    PHP_CFLAGS="-fstack-protector-strong -fpic -fpie" \
    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie" \
    PHP_LDFLAGS="-Wl,-O1 -pie" \
    GPG_KEYS="1198C0117593497A5EC5C199286AF1F9897469DC C28D937575603EB4ABB725861C0779DC5C0A9DE4 AFD8691FDAEDF03BDF6E460563F15A9B715376CA" \
    PHP_VERSION="8.3.10" \
    PHP_URL="https://www.php.net/distributions/php-8.3.10.tar.xz" \
    PHP_ASC_URL="https://www.php.net/distributions/php-8.3.10.tar.xz.asc" \
    PHP_SHA256="a0f2179d00931fe7631a12cbc3428f898ca3d99fe564260c115af381d2a1978d" \
    ADMIN_EMAIL="admin@crackit.co.ke" \
    PHP_TIME_ZONE="UTC" \
    PHP_MEMORY_LIMIT="256M" \
    PHP_UPLOAD_MAX_FILESIZE="32M" \
    PHP_POST_MAX_SIZE="32M" \
    NGINX_VERSION="1.27.0" \
    PKG_RELEASE="2"

# Install dependencies
RUN apk update && apk add --no-cache \
    $PHPIZE_DEPS \
    nginx \
    supervisor \
    curl \
    bash \
    libxml2-dev \
    oniguruma-dev \
    icu-dev \
    zlib-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    git \
    && docker-php-ext-install pdo pdo_mysql mysqli mbstring intl zip xml gd \
    && docker-php-ext-enable sodium \
    && apk --no-cache add \
    libstdc++ \
    unixodbc \
    icu \
    supervisor

# Install Microsoft ODBC and MSSQL tools (manual curl and install)
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.2.1-1_amd64.apk && \
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.10.1.1-1_amd64.apk && \
    apk add --allow-untrusted msodbcsql17_17.10.2.1-1_amd64.apk mssql-tools_17.10.1.1-1_amd64.apk

# Create user and working directory
RUN adduser -D -g '' www-data && \
    mkdir -p /var/www/html && chown www-data:www-data /var/www/html

WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy custom configuration and entrypoint files
COPY docker-vars.ini /usr/local/etc/php/conf.d/docker-vars.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set ports, signals, and entrypoint
EXPOSE 80 9000
STOPSIGNAL SIGQUIT

ENTRYPOINT ["/entrypoint.sh"]