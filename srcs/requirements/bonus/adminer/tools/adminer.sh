#!/bin/bash

if [ ! -f /var/www/html/adminer.php ]; then
    cp /adminer.php /var/www/html/adminer.php
fi

chown -R www-data:www-data /var/www/html
mkdir -p /run/php
exec php-fpm7.4 -F
