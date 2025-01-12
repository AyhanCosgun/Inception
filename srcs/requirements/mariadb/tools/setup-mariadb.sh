#!/bin/bash

GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'

sleep 2

if [ -f /run/secrets/db_password ]; then
    export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/db_root_password ]; then
    export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi


if [ -f /run/secrets/credentials ]; then
    source <(grep -v '^#' /run/secrets/credentials | grep -E '^MYSQL_USER=' | sed 's/ //g')

REQUIRED_VARS=("MYSQL_USER" "MYSQL_PASSWORD" "MYSQL_ROOT_PASSWORD")
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo -e "${RED}Error: Missing required environment variable / credential : $var${RESET}"
        exit 1
    fi
 done


# Start MariaDB service
service mariadb start 2> /dev/mariadb-error-output.txt

sleep 5

mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

# Create database and users
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

echo -e "Shutting down database..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHUTDOWN;"

echo -e "${GREEN}MariaDB setup is complete. ${RESET} The database is ready for connections.\n \
Monitoring logs and executing the main process..."

exec "$@"
