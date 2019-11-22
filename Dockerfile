FROM outeredge/edge-docker-php:7.2-alpine

ARG COMPOSER_AUTH

CMD ["/magento.sh"]

RUN sudo apk add --no-cache \
        libsass \
        php7-gd \
        php7-pecl-imagick \
        php7-soap

COPY . /

ENV MAGENTO_VERSION=2.3.3

RUN composer create-project --no-interaction --prefer-dist --no-dev --repository=https://repo.magento.com/ magento/project-community-edition /var/www ${MAGENTO_VERSION} && \
    sed -i '/^#/d' /var/www/nginx.conf.sample && \
    sed -i "/fastcgi_backend/a \
        fastcgi_param MAGE_MODE \$MAGE_MODE if_not_empty; \
        fastcgi_param MAGE_RUN_CODE \$MAGE_RUN_CODE if_not_empty;" /var/www/nginx.conf.sample && \
    sudo cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf
