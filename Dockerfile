FROM outeredge/edge-docker-php:7.4-alpine

ARG COMPOSER_AUTH

CMD ["/magento.sh"]

RUN sudo apk add --no-cache \
        imagemagick \
        libsass \
        php7-gd \
        php7-pecl-imagick

COPY . /

ENV MAGENTO_VERSION=2.4.2 \
    NGINX_CONF=magento \
    ENABLE_REDIS=On

RUN composer create-project --no-interaction --prefer-dist --no-dev --repository=https://repo.magento.com/ magento/project-community-edition ${WEB_ROOT} ${MAGENTO_VERSION} && \
    composer clear-cache && \
    sed -i '/^#/d' ${WEB_ROOT}/nginx.conf.sample && \
    sed -i "/location \/ {/i {% include '/templates/nginx-vsf.conf.j2' %}" ${WEB_ROOT}/nginx.conf.sample && \
    sed -i "/location \/ {/,+2d" ${WEB_ROOT}/nginx.conf.sample && \
    sed -i "/fastcgi_backend/a \
        fastcgi_param MAGE_MODE \$MAGE_MODE if_not_empty; \
        fastcgi_param MAGE_RUN_CODE \$MAGE_RUN_CODE if_not_empty;" ${WEB_ROOT}/nginx.conf.sample && \
    sudo cp ${WEB_ROOT}/nginx.conf.sample /templates/magento.conf.j2
