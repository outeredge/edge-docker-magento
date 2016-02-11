FROM outeredge/edge-docker-php:7.0.3

# Environment vars
ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    ENABLE_CRON=On \
    MAGENTO_VERSION=2.0.2 \
    MAGE_MODE=developer

# Install npm
RUN apt-get update && \
    apt-get install -y --no-install-recommends ruby nodejs-legacy npm && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

# Add system configuration
COPY . /

# Install magento
RUN wget https://github.com/outeredge/edge-docker-magento/releases/download/${MAGENTO_VERSION}/Magento-CE-${MAGENTO_VERSION}.tar.gz -qO - | tar -zxf - -C /var/www && \
    chmod +x /var/www/bin/magento && \
    cp /var/www/nginx.conf.sample /etc/nginx/magento_default.conf

# Persist certain folders
VOLUME ["/var/www/var/session", "/var/www/pub/media/catalog", "/var/www/pub/media/wysiwyg"]

# Run script for local.xml
CMD ["/run.sh"]
