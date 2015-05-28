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
RUN wget https://github.com/OpenMage/magento-lts/archive/1.9.1.0-lts.tar.gz -O - | tar -zxf - -C /var/www --strip=1

# Setup web server
COPY magento_*.conf /etc/nginx/
COPY php.ini /usr/local/etc/php/conf.d/magento.ini
COPY crontab /etc/
RUN sed -i '/root/a include magento_*.conf;' /templates/nginx-default.conf.j2

# Persist sessions
VOLUME /var/www/var/session

# Run script for local.xml
COPY run.sh /run.sh
CMD ["/run.sh"]
