FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/setup-mariadb.sh /

RUN chmod +x /setup-mariadb.sh

ENTRYPOINT [ "/setup-mariadb.sh" ]
CMD [ "mariadbd" ]

