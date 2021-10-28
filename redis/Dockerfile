###########################################################################
#
# Redis
#
###########################################################################

ARG REDIS_VERSION
FROM redis:${REDIS_VERSION}


#--------------------------------------------------------------------------
# system settings
#--------------------------------------------------------------------------

USER root

# copy configuration file
RUN mkdir -p /usr/local/etc/redis
COPY ./redis.conf /usr/local/etc/redis/redis.conf

# create log directory
RUN mkdir -p /var/log/redis && touch /var/log/redis/redis.log

# timezone
ARG TIMEZONE=UTC
ENV TZ=${TIMEZONE}
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# set locale
RUN set -xe; \
    apt-get update -yqq && \
    apt-get install -yqq locales && \
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

VOLUME /data

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]

EXPOSE 6379
