FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y redis-server && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
