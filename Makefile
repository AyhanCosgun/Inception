all: up

up:
	mkdir -p /home/acosgun/data/wordpress
	mkdir -p /home/acosgun/data/mariadb
	sudo mount --make-shared /
	docker-compose -f ./srcs/docker-compose.yml up --build

down:
	docker-compose -f ./srcs/docker-compose.yml down

start:
	docker-compose -f srcs/docker-compose.yml start

stop:
	docker-compose -f ./srcs/docker-compose.yml stop


clean:
	docker-compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans

fclean:
	docker compose -f ./srcs/docker-compose.yml down --rmi all --volumes --remove-orphans
	sudo rm -rf /home/acosgun/data

re: fclean all


nginx:
	mkdir -p /home/acosgun/data/wordpress
	docker-compose -f srcs/docker-compose.yml up --build nginx

mariadb:
	mkdir -p /home/acosgun/data/mariadb
	docker-compose -f srcs/docker-compose.yml up --build mariadb

wordpress:
	mkdir -p /home/acosgun/data/wordpress
	docker-compose -f srcs/docker-compose.yml up --build wordpress


.PHONY: all up down start stop clean fclean re nginx mariadb wordpress