FROM outeredge/edge-docker-php:7.0.27-alpine

ENV MAGENTO_VERSION=2.1.12 \
    MAGE_MODE=default \
    ADDITIONAL_STORES=

CMD ["/run.sh"]

COPY . /

RUN wget https://github.com/outeredge/edge-docker-magento/releases/download/v${MAGENTO_VERSION}/Magento-CE-${MAGENTO_VERSION}.tar.bz2 -O - | tar -jxf - -C /var/www --exclude='composer.lock' --exclude='*.md' && \
    chmod +x /var/www/bin/magento && \
    cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf && \
    sed -i '/$relativePath = $request->getPathInfo();/a $relativePath = ltrim(ltrim($relativePath, "media"), "/");' /var/www/pub/get.php && \
    sed "s,=> GLOB_BRACE,=> defined('GLOB_BRACE') ? GLOB_BRACE : 0,g" -i /var/www/vendor/zendframework/zend-stdlib/src/Glob.php && \
    chown -R edge:edge /var/www
