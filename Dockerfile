FROM outeredge/edge-docker-php:7.2.17-alpine

CMD ["/run.sh"]

RUN apk add --no-cache \
        libsass \
        php7-gd \
        php7-simplexml \
        php7-soap \
        php7-tokenizer \
        php7-xml \
        php7-xmlwriter \
        php7-xsl

ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    MAGENTO_VERSION=1.9.4.3

RUN wget -nv https://github.com/OpenMage/magento-mirror/archive/${MAGENTO_VERSION}.tar.gz -O - | tar -zxf - -C /var/www --strip=1 --exclude='README.md' && \
    chown -R edge:edge /var/www && \
    chmod +x /var/www/cron.sh

COPY . /

RUN sed -i '/root/a include magento_*.conf;' /templates/nginx-default.conf.j2 && \
    sed -i "s/isset(\$_SERVER\['MAGE_IS_DEVELOPER_MODE'\])/getenv('APPLICATION_ENV') == 'dev'/" index.php && \
    sed -i "/setIsDeveloperMode(true);/a ini_set('display_errors', 1);" index.php && \
    patch -p0 < /uploader.patch
