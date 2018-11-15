#!/bin/bash -ex

if [ ! -z "$ADDITIONAL_STORES" ]; then
    while IFS=',' read -ra HOSTS; do
        for i in "${HOSTS[@]}"; do
            IFS=':' read -ra HOST <<< "$i"

            cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i "/listen/a server_name ${HOST[1]};" /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i "/listen/a fastcgi_param MAGE_RUN_CODE ${HOST[0]};" /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i 's/ reuseport//g' /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i 's/ default_server//g' /etc/nginx/conf.d/${HOST[0]}.conf
        done
    done <<< "$ADDITIONAL_STORES"
fi

MAGE_MODE="${MAGE_MODE:-developer}"

if [[ /var/www/app/etc/env.php -ot /var/www/app/etc/env.php.$MAGE_MODE ]]
then
    cp -p /var/www/app/etc/env.php.$MAGE_MODE /var/www/app/etc/env.php
fi

exec /usr/bin/supervisord
