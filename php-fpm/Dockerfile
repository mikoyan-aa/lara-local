###########################################################################
#
# php-fpm
#
###########################################################################

ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

#--------------------------------------------------------------------------
# libraries & extensions
#--------------------------------------------------------------------------

USER root

RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net

RUN set -xe; \
    apt-get install -yqq \
      gcc \
      g++ \
      make \
      autoconf \
      git

RUN docker-php-ext-install bcmath
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache

# xdebug
ARG XDEBUG_VERSION
ARG XDEBUG_INI_FILE
RUN if [ "X${XDEBUG_VERSION}" = "X" ]; then \
        pecl install xdebug; \
    else \
        pecl install xdebug-${XDEBUG_VERSION}; \
    fi && \
    docker-php-ext-enable xdebug
COPY ${XDEBUG_INI_FILE} /usr/local/etc/php/conf.d/xdebug.ini

# zip
RUN set -xe; \
    apt-get install -yqq zip unzip libzip-dev
RUN docker-php-ext-install zip

# intl
RUN set -xe; \
    apt-get install -yqq libicu-dev
RUN docker-php-ext-install intl

# Redis
RUN set -xe; \
    pecl install redis
RUN docker-php-ext-enable redis

# GD
RUN set -xe; \
    apt-get install -yqq \
      libfreetype6-dev \
      libjpeg-dev \
      libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd


#--------------------------------------------------------------------------
# user related environment
#--------------------------------------------------------------------------

ARG PUID=1000
ARG PGID=1000
ENV PUID=${PUID}
ENV PGID=${PGID}
RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data


#--------------------------------------------------------------------------
# system settings
#--------------------------------------------------------------------------

# PHP configurations
COPY ./laravel.ini /usr/local/etc/php/conf.d
COPY ./xlaravel.pool.conf /usr/local/etc/php-fpm.d/

# timezone
ARG TIMEZONE=UTC
ENV TZ=${TIMEZONE}
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# set locale
RUN apt-get install -yqq locales && \
    echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ARG LOCALE=ja_JP.UTF-8
ENV LANG=${LOCALE}
ENV LC_ALL=${LOCALE}


#--------------------------------------------------------------------------
# clean up & execution
#--------------------------------------------------------------------------
RUN apt-get clean -yqq && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
