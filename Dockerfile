FROM outeredge/edge-docker-php:5.6.7

# Environment vars
ENV APPLICATION_ENV=dev \
    ENABLE_CRON=On

# Install sass & sass-css-importer
RUN apt-get update && \
    apt-get install -y --no-install-recommends ruby && \
    gem install sass --no-rdoc --no-ri -v "~> 3.4.13" && \
    gem install sass-css-importer --no-rdoc --no-ri -v "~> 1.0.0.beta.0" && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

# Install magento with patches
RUN wget https://github.com/OpenMage/magento-lts/archive/1.9.1.1.tar.gz -qO - | tar -zxf - -C /var/www --strip=1

# Apply config & patches
COPY . /
RUN sed -i '/root/a include magento_*.conf;' /templates/nginx-default.conf.j2 && \
    sed -i "s/isset(\$_SERVER\['MAGE_IS_DEVELOPER_MODE'\])/getenv('APPLICATION_ENV') !== 'prod'/" index.php && \
    sed -i "/setIsDeveloperMode(true);/a ini_set('display_errors', 1);" index.php && \
    patch -p0 < /uploader.patch

# Persist sessions
VOLUME /var/www/var/session

# Run script for local.xml
CMD ["/run.sh"]