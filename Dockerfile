FROM outeredge/edge-docker-php:7.1.17-alpine

ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    MAGENTO_VERSION=1.9.3.10

CMD ["/run.sh"]

RUN wget -nv https://github.com/OpenMage/magento-mirror/archive/${MAGENTO_VERSION}.tar.gz -O - | tar -zxf - -C /var/www --strip=1 --exclude='README.md' && \
    chown -R edge:edge /var/www && \
    chmod +x /var/www/cron.sh

COPY . /

RUN sed -i '/root/a include magento_*.conf;' /templates/nginx-default.conf.j2 && \
    sed -i "s/isset(\$_SERVER\['MAGE_IS_DEVELOPER_MODE'\])/getenv('APPLICATION_ENV') == 'dev'/" index.php && \
    sed -i "/setIsDeveloperMode(true);/a ini_set('display_errors', 1);" index.php && \
    patch -p1 < /PATCH-1.9.3.1-1.9.3.9_PHP7-2018-09-13-08-01-43.2_v2 && \
    patch -p0 < /uploader.patch
