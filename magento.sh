#!/bin/bash

if [ -e "$WEB_ROOT/app/etc/env.php.$MAGE_ENV" ]
then
    cp -p $WEB_ROOT/app/etc/env.php.$MAGE_ENV $WEB_ROOT/app/etc/env.php
fi

exec /launch.sh "$@"