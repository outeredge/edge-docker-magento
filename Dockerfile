FROM outeredge/edge-docker-php:7.2

CMD ["/magento.sh"]

RUN sudo apt-get update \
    && sudo apt-get install --no-install-recommends --yes \
        sassc \
        php${PHP_VERSION}-gd \
    # Cleanup
    && sudo rm -rf /var/lib/apt/lists/*

COPY . /

ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    NGINX_CONF=magento \
    MAGE_IS_DEVELOPER_MODE=true \
    MAGENTO_VERSION=1.9.4.5

RUN wget -nv https://github.com/OpenMage/magento-mirror/archive/${MAGENTO_VERSION}.tar.gz -O - | tar -zxf - -C ${WEB_ROOT} --strip=1 --exclude='README.md' && \
    chmod +x ${WEB_ROOT}/cron.sh
