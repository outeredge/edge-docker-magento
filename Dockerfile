FROM outeredge/edge-docker-php:7.0.12

# Environment vars
ENV ADDITIONAL_STORES= \
    ENABLE_CRON=On \
    MAGENTO_VERSION=2.1.2 \
    DB_HOST= \
    DB_USERNAME= \
    DB_PASSWORD= \
    DB_NAME= \
    MAGE_MODE=developer

# Install node
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

# Add system configuration
COPY . /

# Install magento
RUN wget https://github.com/outeredge/edge-docker-magento/releases/download/${MAGENTO_VERSION}/Magento-CE-${MAGENTO_VERSION}.tar.gz -qO - | tar -zxf - -C /var/www && \
    chmod +x /var/www/bin/magento && \
    cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf

# Persist certain folders
VOLUME ["/var/www/var/session", "/var/www/pub/media/catalog", "/var/www/pub/media/wysiwyg"]

# Run
CMD ["/run.sh"]
