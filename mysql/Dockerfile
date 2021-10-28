###########################################################################
#
# MySQL
#
###########################################################################

ARG MYSQL_VERSION
FROM mysql:${MYSQL_VERSION}

#--------------------------------------------------------------------------
# system settings
#--------------------------------------------------------------------------

USER root

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

# MySQL settings
RUN chown -R mysql:root /var/lib/mysql/
COPY my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 0444 /etc/mysql/conf.d/my.cnf


#--------------------------------------------------------------------------
# clean up & execution
#--------------------------------------------------------------------------
RUN apt-get clean -yqq && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

CMD ["mysqld"]

EXPOSE 3306
