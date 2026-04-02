FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y nginx && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Supprime la config par défaut de nginx
RUN rm -f /etc/nginx/sites-enabled/default

COPY conf/index.html /var/www/website/index.html
COPY conf/nginx.conf /etc/nginx/conf.d/website.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
