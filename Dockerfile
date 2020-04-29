FROM outeredge/edge-docker-php:7.1-alpine

CMD ["/magento.sh"]

RUN sudo apk add --no-cache \
        libsass \
        php7-gd

COPY . /

ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    NGINX_CONF=magento \
    MAGE_IS_DEVELOPER_MODE=true \
    MAGENTO_VERSION=1.9.4.5

RUN wget -nv https://github.com/OpenMage/magento-mirror/archive/${MAGENTO_VERSION}.tar.gz -O - | tar -zxf - -C ${WEB_ROOT} --strip=1 --exclude='README.md' && \
    chmod +x ${WEB_ROOT}/cron.sh
