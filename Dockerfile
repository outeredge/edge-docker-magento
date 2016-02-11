FROM outeredge/edge-docker-php:7.0.3

# Environment vars
ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    ENABLE_CRON=On \
    MAGENTO_VERSION=2.0.2

# Install npm
RUN apt-get update && \
    apt-get install -y --no-install-recommends ruby nodejs-legacy npm && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

# Install magento
RUN wget https://github.com/magento/magento2/archive/${MAGENTO_VERSION}.tar.gz -qO - | tar -zxf - -C /var/www --strip=1 --exclude='README.md' && \
    chmod +x /var/www/bin/magento && \
    composer install --no-interaction --optimize-autoloader --prefer-dist --no-dev && \
    composer clear-cache

# Add system configuration
COPY . /

# Persist certain folders
VOLUME ["/var/www/var/session", "/var/www/pub/media/catalog", "/var/www/pub/media/wysiwyg"]

# Run script for local.xml
CMD ["/run.sh"]
