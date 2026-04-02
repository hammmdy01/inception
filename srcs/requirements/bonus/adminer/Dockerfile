FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y php7.4 php7.4-fpm php7.4-mysql wget curl && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Télécharge Adminer
RUN curl -L https://www.adminer.org/latest.php -o /adminer.php

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/adminer.sh /adminer.sh

RUN chmod +x /adminer.sh

EXPOSE 9000

ENTRYPOINT ["/adminer.sh"]
