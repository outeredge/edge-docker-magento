FROM outeredge/edge-docker-php:5.6.7

# Environment vars
ENV APPLICATION_ENV dev

# Install sass & sass-css-importer
RUN apt-get update && \
    apt-get install -y --no-install-recommends ruby && \
    gem install sass --no-rdoc --no-ri -v "~> 3.4.13" && \
    gem install sass-css-importer --no-rdoc --no-ri -v "~> 1.0.0.beta.0" && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

# Install magento with patches
RUN wget https://github.com/OpenMage/magento-lts/archive/1.9.1.0-lts.tar.gz -O - | tar -zxf - -C /var/www --strip=1

# Setup web server
COPY *.conf /etc/nginx/
COPY php.ini /usr/local/etc/php/conf.d/magento.ini
RUN sed -i '/root/a include magento_*.conf;' /etc/nginx/conf.d/default.conf.j2

# File permissions
RUN find . -type f -exec chmod 400 {} \; && \
    find . -type d -exec chmod 500 {} \; && \
    find var/ -type f -exec chmod 600 {} \; && \
    find var/ -type d -exec chmod 700 {} \; && \
    find media/ -type f -exec chmod 600 {} \; && \
    find media/ -type d -exec chmod 700 {} \; && \
    chmod 700 includes && \
    chmod 600 includes/config.php && \
    chmod 700 app/etc && \
    chmod 600 app/etc/*.xml && \
    chown -R www-data:www-data /var/www

# Run script for local.xml
COPY run.sh /run.sh
CMD ["/run.sh"]