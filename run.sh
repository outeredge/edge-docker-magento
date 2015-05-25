#!/bin/bash -e

if [[ /var/www/app/etc/local.xml -ot /var/www/app/etc/local.$APPLICATION_ENV.xml ]]
then
    cp /var/www/app/etc/local.$APPLICATION_ENV.xml /var/www/app/etc/local.xml
fi

chmod -R 770 /var/www/media /var/www/var

/usr/bin/supervisord
