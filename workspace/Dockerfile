###########################################################################
#
# workspace
#
###########################################################################

ARG PHP_VERSION
FROM php:${PHP_VERSION}


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
      git \
      cron \
      default-mysql-client

RUN docker-php-ext-install bcmath
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache

# composer
ARG COMPOSER_VERSION=2
ENV COMPOSER_VERSION=${COMPOSER_VERSION}
RUN set -xe; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { \
        echo 'Installer verified'; \
    } else { \
        echo 'Installer corrupt'; \
        unlink('composer-setup.php'); \
    } echo PHP_EOL;"; \
    php composer-setup.php --filename=composer --install-dir=/usr/local/bin --${COMPOSER_VERSION}; \
    php -r "unlink('composer-setup.php');"

# zip
RUN set -xe; \
    apt-get install -yqq zip unzip libzip-dev
RUN docker-php-ext-install zip

# pcntl
RUN docker-php-ext-install pcntl

# sodium
RUN set -xe; \
    apt-get install -yqq libsodium-dev
RUN docker-php-ext-install sodium

# GD
RUN set -xe; \
    apt-get install -yqq \
      libfreetype6-dev \
      libjpeg-dev \
      libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# npm, n and NodeJS
RUN set -xe; \
    apt-get install -yqq \
      npm
RUN npm install npm@latest -g
RUN npm install -g n
RUN n latest


#--------------------------------------------------------------------------
# user related environment
#--------------------------------------------------------------------------

ARG PUID=1000
ARG PGID=1000
ENV PUID=${PUID}
ENV PGID=${PGID}
ARG WORKSPACE_USER
ARG WORKSPACE_GROUP
RUN groupadd -g ${PGID} ${WORKSPACE_GROUP} && \
    useradd -m -l -u ${PUID} -g ${WORKSPACE_GROUP} ${WORKSPACE_USER} && \
    usermod -p "*" -s /bin/bash ${WORKSPACE_USER}


#--------------------------------------------------------------------------
# system settings
#--------------------------------------------------------------------------

# PHP configurations
COPY ./memory.ini /usr/local/etc/php/conf.d

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

# set cron
COPY ./crontab /etc/cron.d
RUN chmod -R 644 /etc/cron.d

# set initialization script
COPY scripts/docker-entrypoint.sh /
RUN chmod 500 /docker-entrypoint.sh


#--------------------------------------------------------------------------
# user settings
#--------------------------------------------------------------------------
USER ${WORKSPACE_USER}

# phpunit-watcher
RUN composer global require spatie/phpunit-watcher
USER root
RUN ln -s /home/${WORKSPACE_USER}/.composer/vendor/bin/phpunit-watcher /usr/local/bin


#--------------------------------------------------------------------------
# clean up
#--------------------------------------------------------------------------

RUN apt-get clean -yqq && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# set workdir
WORKDIR /var/www

CMD ["/docker-entrypoint.sh", "bash"]
