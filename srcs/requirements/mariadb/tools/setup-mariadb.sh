#!/bin/bash

GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'

sleep 2

if [ -f /run/secrets/db_password ] && [ ! -z "$(cat /run/secrets/db_password)" ]; then
    export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
else
    echo -e "${RED}db_password secret file is missing OR empty !${RESET}"
    exit 1
fi

if [ -f /run/secrets/db_root_password ] && [ ! -z "$(cat /run/secrets/db_root_password)" ]; then
    export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
else
    echo -e "${RED}db_root_password secret file is missing OR empty !${RESET}"
    exit 1
fi


if [ -f /run/secrets/credentials ]; then
    export MYSQL_USER=$(grep MYSQL_USER /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')

    if [ -z "$MYSQL_USER" ] ; then
    echo -e "${RED}credentials file is empty !${RESET}"
    exit 1
fi
else
    echo -e "${RED}credentials file is missing !${RESET}"
    exit 1
fi
 

# Start MariaDB service
service mariadb start 2> /dev/mariadb-error-output.txt

sleep 5

mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

# Create users
echo -e "Setting database [${BLUE}$MYSQL_DATABASE]${RESET}..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

echo -e "Setting mysql user [${BLUE}$MYSQL_USER]${RESET}..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

echo -e "Giving permissions to database to user [${BLUE}$MYSQL_DATABASE]${RESET}..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

echo -e "Flushing privileges to apply changes${RESET}..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"


echo -e "Shutting down database${RESET}..." && \
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHUTDOWN;"

echo -e "${GREEN}MariaDB setup is complete. The database is ready for connections.${RESET} Monitoring logs and executing the main process...${RESET}"

exec "$@"
