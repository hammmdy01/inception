FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y php7.4 php7.4-fpm php7.4-mysql wget && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Télécharge Adminer
RUN wget https://www.adminer.org/latest.php -O /var/www/html/adminer.php

RUN chown -R www-data:www-data /var/www/html

COPY tools/adminer.sh /adminer.sh
RUN chmod +x /adminer.sh

EXPOSE 8080

ENTRYPOINT ["/adminer.sh"]