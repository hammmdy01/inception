FROM debian:bullseye

RUN apt update && apt upgrade -y && \
    apt install -y mariadb-server && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/create_db.sh /create_db.sh
RUN chmod +x /create_db.sh

EXPOSE 3306

ENTRYPOINT ["/create_db.sh"]