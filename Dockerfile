FROM outeredge/edge-docker-php:7.2.17-alpine

RUN apk add --no-cache \
        libsass \
        php7-gd \
        php7-simplexml \
        php7-soap \
        php7-tokenizer \
        php7-xmlwriter \
        php7-xml \
        php7-xsl \
        php7-pecl-imagick        

CMD ["/run.sh"]

ENV MAGENTO_VERSION=2.3.1

ARG COMPOSER_AUTH

COPY . /

RUN composer create-project --no-interaction --prefer-dist --no-dev --repository=https://repo.magento.com/ magento/project-community-edition . ${MAGENTO_VERSION} && \
    composer clear-cache && \
    rm -f composer.lock && \
    sed -i '/$relativePath = $request->getPathInfo();/a $relativePath = ltrim(ltrim($relativePath, "media"), "/");' /var/www/pub/get.php && \
    cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf && \
    sed -i '/^#/d' /etc/nginx/magento_default.conf && \
    sed -i "/fastcgi_backend/a \
        fastcgi_param MAGE_MODE \$MAGE_MODE if_not_empty; \
        fastcgi_param MAGE_RUN_CODE \$MAGE_RUN_CODE if_not_empty;" /etc/nginx/magento_default.conf && \
    chown -R edge:edge /var/www
