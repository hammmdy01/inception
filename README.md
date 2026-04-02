# Inception

*This project has been created as part of the 42 curriculum by hazali.*

## Description

Inception is a system administration project that consists of setting up a small infrastructure using Docker and Docker Compose. The goal is to virtualize several services, each running in its own dedicated container, all orchestrated together via a single `docker-compose.yml` file.

The infrastructure includes:
- A **NGINX** container serving as the only entry point via HTTPS (port 443) with TLSv1.2/TLSv1.3
- A **WordPress + PHP-FPM** container handling the web application
- A **MariaDB** container managing the database
- Two **named volumes** for data persistence (WordPress files and database)
- A **Docker network** connecting all containers

### Design Choices

#### Virtual Machines vs Docker
A Virtual Machine emulates an entire operating system including its kernel, requiring significant resources. Docker containers share the host OS kernel and only package the application and its dependencies, making them much lighter and faster to start. However, VMs provide stronger isolation. For this project, Docker is ideal because each service is independent and lightweight.

#### Secrets vs Environment Variables
Environment variables (via `.env` file) store configuration values that are passed to containers at runtime. Docker Secrets are more secure as they are stored encrypted and only exposed to containers that need them. In this project, we use a `.env` file for configuration — the file must never be committed to git. For production, Docker Secrets would be the recommended approach.

#### Docker Network vs Host Network
With `network: host`, the container shares the host's network stack directly, meaning no isolation. With a Docker named network (bridge mode), containers get their own isolated network and can communicate using container names as hostnames (e.g., `mariadb:3306`). The sujet forbids `network: host` for good reason — it breaks isolation.

#### Docker Volumes vs Bind Mounts
Bind mounts link a host directory directly to a container path. Named volumes are managed by Docker and stored in Docker's data directory. Named volumes are more portable and safer for production use. The sujet requires named volumes stored at `/home/hazali/data` on the host.

## Instructions

### Prerequisites
- Docker and Docker Compose installed
- A virtual machine running Debian/Ubuntu
- The domain `hazali.42.fr` pointing to `127.0.0.1` in `/etc/hosts`

### Installation

```bash
# Clone the repository
git clone <repo_url> inception
cd inception

# Add domain to /etc/hosts
echo "127.0.0.1 hazali.42.fr" >> /etc/hosts

# Build and start all containers
make
```

### Access
- Website: `https://hazali.42.fr`
- WordPress Admin: `https://hazali.42.fr/wp-admin`

### Stop the project
```bash
make down
```

### Clean everything
```bash
make clean
```

## Resources

### Documentation
- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [WordPress WP-CLI documentation](https://wp-cli.org/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)
- [OpenSSL documentation](https://www.openssl.org/docs/)
- [TLS/SSL explained](https://www.cloudflare.com/learning/ssl/what-is-ssl/)
- [GradeMe Inception tutorial](https://tuto.grademe.fr/inception/)

### AI Usage
AI (Claude by Anthropic) was used during this project for the following tasks:
- Debugging Dockerfile errors (wrong package names, missing CMD instructions)
- Understanding why Debian Buster repositories returned 404 errors and switching to Bullseye
- Generating and explaining the MariaDB setup script logic
- Explaining the difference between `daemon off` in NGINX and why it matters for Docker
- Explaining PHP-FPM configuration and the `clear_env = no` directive
- Helping structure the docker-compose.yml and understanding volume/network configuration
- Generating this documentation

All AI-generated content was reviewed, tested, and fully understood before being included in the project.
