FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    gcc \
    make \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    apt-get install -yqq \
    apt-utils \
    libzip-dev zip unzip && \
    docker-php-ext-configure zip; \
    docker-php-ext-install zip && \
    php -m | grep -q 'zip'
RUN docker-php-ext-install pdo_mysql
RUN apt-get install -y nano
RUN apt-get install -y build-essential cron
RUN apt-get install -y cron
RUN apt-get install -y procps
RUN apt-get install -y net-tools
RUN apt-get update && apt-get install libmagickwand-dev -y --no-install-recommends \
    && pecl install imagick-3.5.1 \
    && docker-php-ext-enable imagick
RUN apt-get install -y ghostscript
COPY --from=composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin
RUN apt-get install -y git