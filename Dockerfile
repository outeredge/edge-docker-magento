FROM outeredge/edge-docker-php:5.6.7

# Environment vars
ENV APPLICATION_ENV dev

# Install magento
RUN wget https://github.com/OpenMage/magento-mirror/archive/1.9.1.0.tar.gz -O - | tar -zxf - -C /var/www --strip=1

# Install sass
RUN apt-get update && \
    apt-get install -y --no-install-recommends ruby && \
    gem install sass --no-rdoc --no-ri -v "~> 3.4.13" && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

# Setup web server
COPY nginx.conf /etc/nginx/conf.d/default
COPY php.ini /usr/local/etc/php/conf.d/magento.ini

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