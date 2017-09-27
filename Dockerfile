FROM outeredge/edge-docker-php:7.0.23-alpine

ENV MAGENTO_VERSION=2.1.9 \
    MAGE_MODE=default \
    ADDITIONAL_STORES=

VOLUME ["/var/www/var/session", "/var/www/pub/media/catalog", "/var/www/pub/media/wysiwyg"]

CMD ["/run.sh"]

COPY . /

RUN wget https://github.com/outeredge/edge-docker-magento/releases/download/${MAGENTO_VERSION}/Magento-CE-${MAGENTO_VERSION}.tar.bz2 -O - | tar -jxf - -C /var/www --exclude='composer.lock' --exclude='*.md' && \
    chmod +x /var/www/bin/magento && \
    cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf && \
    sed -i '/$relativePath = $request->getPathInfo();/a $relativePath = ltrim($relativePath, "media/");' /var/www/pub/get.php

# Fix GLOB_BRACE bug until Magento 2.2
# https://github.com/zendframework/zend-stdlib/issues/58
RUN sed "s,=> GLOB_BRACE,=> defined('GLOB_BRACE') ? GLOB_BRACE : 0,g" -i /var/www/vendor/zendframework/zend-stdlib/src/Glob.php

