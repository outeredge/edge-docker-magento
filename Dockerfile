FROM outeredge/edge-docker-php:7.2-alpine

CMD ["/magento.sh"]

RUN sudo apk add --no-cache \
        libsass \
        php7-gd

COPY . /

ENV APPLICATION_ENV=dev \    
    ADDITIONAL_STORES= \
    MAGE_ROOT=/var/www \
    MAGENTO_VERSION=1.9.4.3

RUN wget -nv https://github.com/OpenMage/magento-mirror/archive/${MAGENTO_VERSION}.tar.gz -O - | tar -zxf - -C /var/www --strip=1 --exclude='README.md' && \
    chmod +x /var/www/cron.sh

RUN sed -i "s/isset(\$_SERVER\['MAGE_IS_DEVELOPER_MODE'\])/getenv('APPLICATION_ENV') == 'dev'/" index.php && \
    sed -i "/setIsDeveloperMode(true);/a ini_set('display_errors', 1);" index.php && \
    patch -p0 < /uploader.patch
