FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y wget php7.4 php7.4-fpm php7.4-mysql \
    php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml \
    mariadb-client && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Télécharge WordPress
RUN wget https://fr.wordpress.org/wordpress-6.4-fr_FR.tar.gz -P /var/www && \
    cd /var/www && tar -xzf wordpress-6.4-fr_FR.tar.gz && \
    rm wordpress-6.4-fr_FR.tar.gz && \
    chown -R www-data:www-data /var/www/wordpress

# Installe WP-CLI (outil pour configurer WordPress en ligne de commande)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Remplace la config PHP-FPM par la nôtre
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/auto_config.sh /auto_config.sh
RUN chmod +x /auto_config.sh

EXPOSE 9000

ENTRYPOINT ["/auto_config.sh"]