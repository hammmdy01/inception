all:
	@mkdir -p /home/hazali/data/wordpress
	@mkdir -p /home/hazali/data/mariadb
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@docker compose -f srcs/docker-compose.yml down

clean:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all

re: clean all

.PHONY: all down clean re