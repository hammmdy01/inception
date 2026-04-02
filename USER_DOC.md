# User Documentation

## What services does the stack provide?

The Inception stack runs 3 services:

| Service | Role | Port |
|---------|------|------|
| NGINX | Web server / entry point | 443 (HTTPS) |
| WordPress + PHP-FPM | Web application | 9000 (internal) |
| MariaDB | Database | 3306 (internal) |

Only port **443** is exposed to the outside. WordPress and MariaDB communicate internally through the Docker network.

---

## Start the project

```bash
cd inception
make
```

This will build all Docker images and start all containers in the background.

---

## Stop the project

```bash
make down
```

This stops and removes the containers but **keeps your data** (volumes are preserved).

---

## Access the website

Open your browser and go to:

```
https://hazali.42.fr
```

You will see a security warning because the SSL certificate is self-signed. This is normal for a local project. Click **Advanced** then **Accept the risk and continue** (Firefox) or **thisisunsafe** (Chrome).

---

## Access the administration panel

```
https://hazali.42.fr/wp-admin
```

Log in with the administrator credentials defined in your `.env` file:
- **Username**: value of `WP_ADMIN`
- **Password**: value of `WP_ADMIN_PASS`

---

## Locate and manage credentials

All credentials are stored in `srcs/.env`. This file is **never committed to git**.

```
srcs/.env
```

It contains:
- `SQL_DATABASE` — MariaDB database name
- `SQL_USER` / `SQL_PASSWORD` — MariaDB user credentials
- `SQL_ROOT_PASSWORD` — MariaDB root password
- `WP_ADMIN` / `WP_ADMIN_PASS` / `WP_ADMIN_EMAIL` — WordPress admin credentials
- `WP_USER` / `WP_USER_PASS` / `WP_USER_EMAIL` — WordPress standard user credentials
- `DOMAIN_NAME` — the domain name of the site

---

## Check that services are running correctly

```bash
docker ps
```

You should see 3 containers with status `Up`:
- `nginx`
- `wordpress`
- `mariadb`

To check the logs of a specific container:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

To check that the website responds:

```bash
curl -k https://hazali.42.fr
```

The `-k` flag ignores the self-signed certificate warning.
