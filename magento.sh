#!/bin/bash

if [ ! -z "$ADDITIONAL_STORES" ]; then
    while IFS=',' read -ra HOSTS; do
        for i in "${HOSTS[@]}"; do
            IFS=':' read -ra HOST <<< "$i"
            sudo cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i "/listen/a server_name ${HOST[1]};" /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i 's/ reuseport//g' /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i 's/ default_server//g' /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i "/set \$MAGE_RUN_CODE/c\set \$MAGE_RUN_CODE ${HOST[0]};" /etc/nginx/conf.d/${HOST[0]}.conf
        done
    done <<< "$ADDITIONAL_STORES"
fi

if [ -e "$WEB_ROOT/app/etc/env.php.$MAGE_ENV" ]
then
    cp -p $WEB_ROOT/app/etc/env.php.$MAGE_ENV $WEB_ROOT/app/etc/env.php
fi

exec /launch.sh
