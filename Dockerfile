FROM outeredge/edge-docker-php:7.0.19

# Environment vars
ENV APPLICATION_ENV=dev \
    ADDITIONAL_STORES= \
    ENABLE_CRON=On \
    MAGENTO_VERSION=1.9.3.3

# Install npm
RUN apt-get update && apt-get install -y --no-install-recommends nodejs-legacy npm && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

# Install magento
RUN wget https://github.com/OpenMage/magento-mirror/archive/${MAGENTO_VERSION}.tar.gz -qO - | tar -zxf - -C /var/www --strip=1 --exclude='README.md' && \
    chmod +x /var/www/cron.sh

# Apply config & patches
COPY . /
RUN sed -i '/root/a include magento_*.conf;' /templates/nginx-default.conf.j2 && \
    sed -i "s/isset(\$_SERVER\['MAGE_IS_DEVELOPER_MODE'\])/getenv('APPLICATION_ENV') == 'dev'/" index.php && \
    sed -i "/setIsDeveloperMode(true);/a ini_set('display_errors', 1);" index.php && \
    patch -p0 < /uploader.patch

# Persist certain folders
VOLUME ["/var/www/var/session", "/var/www/media/catalog", "/var/www/media/wysiwyg"]

# Run script for local.xml
CMD ["/run.sh"]
