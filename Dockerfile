FROM outeredge/edge-docker-php:1.2.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php5-mcrypt php5-gd sendmail && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN php5enmod mcrypt

RUN gem install sass --no-rdoc --no-ri

RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 40M/" /etc/php5/apache2/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 40M/" /etc/php5/apache2/php.ini

RUN wget https://github.com/OpenMage/magento-mirror/archive/1.9.1.0.tar.gz && \
    tar -zxvf 1.9.1.0.tar.gz && \
    rm 1.9.1.0.tar.gz && \
    mv magento-mirror-1.9.1.0 public

RUN cd public && chmod -R 777 media var app/etc

ADD run.sh /run.sh
RUN chmod +x /run.sh

ENV APPLICATION_ENV dev

WORKDIR /var/www/public

CMD ["/run.sh"]
