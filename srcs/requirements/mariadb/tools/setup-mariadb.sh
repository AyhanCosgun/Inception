#!/bin/bash

GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'

sleep 2

export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_USER=$(grep MYSQL_USER /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
export MYSQL_DATABASE=$(grep MYSQL_DATABASE /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
 

####################################################
# Start MariaDB service and check permissions

service mariadb start 2> /dev/mariadb-error-output.txt

sleep 5

echo -e "Running SQL setup script..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" < ./init-users.sql 2>> /dev/mariadb-error-output.txt

echo -e "Shutting down database${RESET}..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHUTDOWN;"

echo -e "${GREEN}MariaDB setup is complete. The database is ready for connections.${RESET} Monitoring logs and executing the main process...${RESET}"

exec "$@"
