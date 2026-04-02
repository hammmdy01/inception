# Developer Documentation

## Prerequisites

- A Virtual Machine running Debian Bullseye or Ubuntu
- Docker and Docker Compose installed
- Git installed
- `make` installed
- Root or sudo access on the VM

### Install dependencies on a fresh Debian VM

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git make docker.io docker-compose
sudo usermod -aG docker $USER
# Log out and back in for the group change to take effect
```

---

## Project structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env               ← environment variables (never commit this)
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       └── nginx.conf
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── www.conf
        │   └── tools/
        │       └── auto_config.sh
        └── mariadb/
            ├── Dockerfile
            ├── conf/
            │   └── 50-server.cnf
            └── tools/
                └── create_db.sh
```

---

## Configuration files

### `srcs/.env`

Create this file before launching the project. It must never be committed to git.

```env
DOMAIN_NAME=hazali.42.fr

SQL_DATABASE=wordpress
SQL_USER=hazali
SQL_PASSWORD=yourpassword
SQL_ROOT_PASSWORD=yourrootpassword

WP_ADMIN=hazali_wp
WP_ADMIN_PASS=adminpassword
WP_ADMIN_EMAIL=hazali@42.fr

WP_USER=hazali_user
WP_USER_EMAIL=user@hazali.fr
WP_USER_PASS=userpassword
```

### `/etc/hosts` on the VM

```bash
echo "127.0.0.1 hazali.42.fr" >> /etc/hosts
```

---

## Build and launch the project

```bash
# Clone the repo
git clone <repo_url> inception
cd inception

# Configure /etc/hosts
echo "127.0.0.1 hazali.42.fr" >> /etc/hosts

# Create the data directories and build+start everything
make
```

The `make` command:
1. Creates `/home/hazali/data/wordpress` and `/home/hazali/data/mariadb`
2. Runs `docker compose up -d --build`

---

## Useful commands to manage containers and volumes

```bash
# See running containers
docker ps

# See all containers including stopped ones
docker ps -a

# See logs of a container
docker logs nginx
docker logs wordpress
docker logs mariadb

# Follow logs in real time
docker compose -f srcs/docker-compose.yml logs -f

# Enter a running container
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash

# Stop containers (keeps volumes)
make down

# Stop containers and remove volumes and images
make clean

# Rebuild everything from scratch
make re

# Remove all Docker cache (use with caution)
docker system prune -af
```

---

## Where is the data stored and how does it persist?

Docker named volumes are used for data persistence. The data is stored on the host VM at:

| Volume | Host path | Container path |
|--------|-----------|----------------|
| `wordpress` | `/home/hazali/data/wordpress` | `/var/www/wordpress` |
| `mariadb` | `/home/hazali/data/mariadb` | `/var/lib/mysql` |

Even if containers are stopped or removed with `make down`, the data persists in these directories. It is only deleted when running `make clean` which passes the `-v` flag to docker compose down.

---

## How each service works

### NGINX
- Entry point of the infrastructure on port 443
- Serves WordPress static files directly from the shared volume
- Forwards PHP requests to WordPress container on port 9000 via FastCGI
- Uses a self-signed TLSv1.2/TLSv1.3 certificate generated with OpenSSL

### WordPress + PHP-FPM
- Downloads and installs WordPress on first start using WP-CLI
- Connects to MariaDB using the credentials from `.env`
- PHP-FPM listens on port 9000 for requests from NGINX
- The `wp-config.php` is only generated once (checked by the setup script)

### MariaDB
- Initializes the database on first start
- Creates the WordPress database and user from `.env` variables
- Listens on port 3306, accessible only within the Docker network
