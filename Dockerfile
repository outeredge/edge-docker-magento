FROM outeredge/edge-docker-php:7.0.23-alpine

ENV ADDITIONAL_STORES= \
    ENABLE_CRON=Off \
    MAGENTO_VERSION=2.1.9 \
    MAGE_MODE=default

VOLUME ["/var/www/var/session", "/var/www/pub/media/catalog", "/var/www/pub/media/wysiwyg"]

CMD ["/run.sh"]

COPY . /

RUN wget https://github.com/outeredge/edge-docker-magento/releases/download/${MAGENTO_VERSION}/Magento-CE-${MAGENTO_VERSION}.tar.bz2 -qO - | tar -jxf - -C /var/www --exclude='composer.lock' --exclude='*.md' && \
    chmod +x /var/www/bin/magento && \
    cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf

