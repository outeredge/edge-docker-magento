FROM outeredge/edge-docker-php:5.6-alpine

CMD ["/magento.sh"]

RUN sudo apk add --no-cache \
        libsass \
        php5-gd

COPY . /

ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    MAGE_ROOT=/var/www \
    MAGE_IS_DEVELOPER_MODE=true \
    MAGENTO_VERSION=1.9.4.4

RUN wget -nv https://github.com/OpenMage/magento-mirror/archive/${MAGENTO_VERSION}.tar.gz -O - | tar -zxf - -C /var/www --strip=1 --exclude='README.md' && \
    chmod +x /var/www/cron.sh
