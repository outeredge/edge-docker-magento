#!/bin/bash -e

if [ ! -z "$ADDITIONAL_STORES" ]; then
    while IFS=',' read -ra HOSTS; do
        for i in "${HOSTS[@]}"; do
            IFS=':' read -ra HOST <<< "$i"

            cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i "/root/a server_name ${HOST[1]};" /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i "/fastcgi_pass/i fastcgi_param MAGE_RUN_CODE ${HOST[0]};" /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i 's/ reuseport//g' /etc/nginx/conf.d/${HOST[0]}.conf
            sed -i 's/ default_server//g' /etc/nginx/conf.d/${HOST[0]}.conf

            if [ -f "/etc/ssl/certs/ssl-cert-${HOST[0]}.pem" ]; then
                sed -i "s/ssl-cert.pem/ssl-cert-${HOST[0]}.pem/" /etc/nginx/conf.d/${HOST[0]}.conf

                if [ -f "/etc/ssl/private/ssl-cert-${HOST[0]}.key" ]; then
                    sed -i "s/ssl-cert.key/ssl-cert-${HOST[0]}.key/" /etc/nginx/conf.d/${HOST[0]}.conf
                fi

                if [ -f "/etc/ssl/certs/ssl-chain-${HOST[0]}.pem" ]; then
                    sed -i "s/ssl-chain.pem/ssl-chain-${HOST[0]}.pem/" /etc/nginx/conf.d/${HOST[0]}.conf
                fi
            else
                sed -i '/listen 443/,/root/ {/root/!d}' /etc/nginx/conf.d/${HOST[0]}.conf
            fi
        done
    done <<< "$ADDITIONAL_STORES"
fi

if [[ /var/www/app/etc/env.php -ot /var/www/app/etc/env.php.$MAGE_MODE ]]
then
    cp /var/www/app/etc/env.php.$MAGE_MODE /var/www/app/etc/env.php
fi

if [[ $MAGE_MODE = "developer" ]] && [[ $(composer show -D | grep magento/product-community-edition) != *"$MAGENTO_VERSION"* ]]; then
  composer require magento/product-community-edition:$MAGENTO_VERSION
fi

rm -rf /var/www/var/cache/* /var/www/public/static /var/www/var/di /var/www/media/js /var/www/media/css /var/www/media/css_secure /var/www/cachebuster.php

/usr/bin/supervisord
