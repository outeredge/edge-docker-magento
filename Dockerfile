FROM outeredge/edge-docker-php:7.1-alpine

ARG COMPOSER_AUTH

CMD ["/magento.sh"]

RUN sudo apk add --no-cache \
        libsass \
        php7-gd

COPY . /

ENV MAGENTO_VERSION=2.2.10 \
    MAGE_ROOT=/var/www

RUN composer create-project --no-interaction --prefer-dist --no-dev --repository=https://repo.magento.com/ magento/project-community-edition ${MAGE_ROOT} ${MAGENTO_VERSION} && \
    composer clear-cache && \
    sed -i '/^#/d' ${MAGE_ROOT}/nginx.conf.sample && \
    sed -i "/fastcgi_backend/a \
        fastcgi_param MAGE_MODE \$MAGE_MODE if_not_empty; \
        fastcgi_param MAGE_RUN_CODE \$MAGE_RUN_CODE if_not_empty;" ${MAGE_ROOT}/nginx.conf.sample && \
    sudo cp ${MAGE_ROOT}/nginx.conf.sample /etc/nginx/magento_default.conf
