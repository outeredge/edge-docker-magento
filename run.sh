#!/bin/bash -e

while IFS=',' read -ra HOSTS; do
    for i in "${HOSTS[@]}"; do
        IFS=':' read -ra HOST <<< "$i"

        cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/${HOST[0]}.conf
        sed -i '/root/a server_name ${HOST[2]:-$HOST[0]};' /etc/nginx/conf.d/${HOST[0]}.conf
        sed -i 's/ssl-cert.pem/ssl-cert-${HOST[0]}.pem/' /etc/nginx/conf.d/${HOST[0]}.conf
        sed -i '/fastcgi_pass/i fastcgi_param MAGE_RUN_CODE ${HOST[1]:-$HOST[0]};' /etc/nginx/conf.d/${HOST[0]}.conf

    done
done <<< "$ADDITIONAL_HOSTS"

if [[ /var/www/app/etc/local.xml -ot /var/www/app/etc/local.$APPLICATION_ENV.xml ]]
then
    cp /var/www/app/etc/local.$APPLICATION_ENV.xml /var/www/app/etc/local.xml
fi

/usr/bin/supervisord