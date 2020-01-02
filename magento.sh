#!/bin/bash -e

if [[ -f $MAGE_ROOT/index.php ]]; then
    sed -i "s/isset(\$_SERVER\['MAGE_IS_DEVELOPER_MODE'\])/getenv('APPLICATION_ENV') == 'dev'/" $MAGE_ROOT/index.php && \
    sed -i "/setIsDeveloperMode(true);/a ini_set('display_errors', 1);" $MAGE_ROOT/index.php && \
    patch -d $MAGE_ROOT -p0 < /uploader.patch
fi

if [ ! -z "$ADDITIONAL_STORES" ]; then
    while IFS=',' read -ra HOSTS; do
        for i in "${HOSTS[@]}"; do
            IFS=':' read -ra HOST <<< "$i"
            sudo cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i "/root/a server_name ${HOST[1]};" /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i "/fastcgi_pass/i fastcgi_param MAGE_RUN_CODE ${HOST[0]};" /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i 's/ reuseport//g' /etc/nginx/conf.d/${HOST[0]}.conf
            sudo sed -i 's/ default_server//g' /etc/nginx/conf.d/${HOST[0]}.conf
        done
    done <<< "$ADDITIONAL_STORES"
fi

if [[ $MAGE_ROOT/app/etc/local.xml -ot $MAGE_ROOT/app/etc/local.xml.$APPLICATION_ENV ]]
then
    cp -p $MAGE_ROOT/app/etc/local.xml.$APPLICATION_ENV $MAGE_ROOT/app/etc/local.xml
fi

exec /launch.sh
