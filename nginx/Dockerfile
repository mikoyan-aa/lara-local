###########################################################################
#
# nginx
#
###########################################################################

FROM nginx:mainline-alpine

#--------------------------------------------------------------------------
# libraries & extensions
#--------------------------------------------------------------------------

COPY nginx.conf /etc/nginx/

RUN apk update && apk upgrade && \
    apk add openssl && \
    apk add bash


#--------------------------------------------------------------------------
# system settings
#--------------------------------------------------------------------------

RUN set -x ; \
    addgroup -g 82 -S www-data ; \
    adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

# timezone
ARG TIMEZONE=UTC
ENV TZ=${TIMEZONE}
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# set locale
ARG LOCALE=UTF-8
ENV LC_ALL=${LOCALE}


#--------------------------------------------------------------------------
# set upstream configuration and remove default.conf
#--------------------------------------------------------------------------
ARG PHP_UPSTREAM_PORT=19000
ENV PHP_UPSTREAM_PORT=${PHP_UPSTREAM_PORT}
RUN echo "upstream php-upstream { server php-fpm:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf

# remove exist default.conf
RUN rm /etc/nginx/conf.d/default.conf


#--------------------------------------------------------------------------
# clean up & execution
#--------------------------------------------------------------------------

CMD ["nginx"]

EXPOSE 80
