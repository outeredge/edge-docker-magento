#!/bin/bash

if [[ ! -e /var/www/public/app/etc/local.xml ]]
then
    cp /var/www/public/app/etc/local.$APPLICATION_ENV.xml /var/www/public/app/etc/local.xml
fi

/apache.sh
