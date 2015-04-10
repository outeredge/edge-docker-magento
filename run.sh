#!/bin/bash

if [[ /var/www/app/etc/local.xml -ot /var/www/app/etc/local.$APPLICATION_ENV.xml ]]
then
    cp /var/www/app/etc/local.$APPLICATION_ENV.xml /var/www/app/etc/local.xml
fi

/usr/bin/supervisord