FROM outeredge/edge-docker-php:7.1.17-alpine

ENV MAGENTO_VERSION=2.2.5

CMD ["/run.sh"]

COPY . /

RUN wget https://github.com/outeredge/edge-docker-magento/releases/download/v${MAGENTO_VERSION}/Magento-CE-${MAGENTO_VERSION}.tar.bz2 -O - | tar -jxf - -C /var/www --exclude='composer.lock' --exclude='*.md' && \
    sed -i '/$relativePath = $request->getPathInfo();/a $relativePath = ltrim(ltrim($relativePath, "media"), "/");' /var/www/pub/get.php && \
    chmod +x /var/www/bin/magento && \
    cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf && \
    chown -R edge:edge /var/www
