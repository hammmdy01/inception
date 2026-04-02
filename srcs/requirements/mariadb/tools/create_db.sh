#!/bin/bash

# Crée le dossier pour le socket s'il n'existe pas
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialise la base de données si c'est la première fois
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Démarre MariaDB en background temporairement
mysqld_safe --skip-networking &
sleep 5

# Configure la base
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Éteint le MariaDB temporaire
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
sleep 2

# Relance en foreground (PID 1)
exec mysqld_safe