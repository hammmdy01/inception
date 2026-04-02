#!/bin/bash

sleep 10  # Attend que MariaDB soit bien démarré

cd /var/www/wordpress

if [ ! -f wp-config.php ]; then

    wp config create \
        --allow-root \
        --dbname=${SQL_DATABASE} \
        --dbuser=${SQL_USER} \
        --dbpass=${SQL_PASSWORD} \
        --dbhost=mariadb:3306 \
        --path=/var/www/wordpress

    wp core install \
        --allow-root \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN} \
        --admin_password=${WP_ADMIN_PASS} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --path=/var/www/wordpress

    wp user create \
        --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASS} \
        --role=author \
        --path=/var/www/wordpress
fi

# Crée le dossier nécessaire à PHP-FPM
mkdir -p /run/php

# Lance PHP-FPM en foreground
exec /usr/sbin/php-fpm7.4 -F