#!/bin/bash

CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
RESET='\033[0m'

sleep 10


prepare_environment()
{
    chown -R www-data: /var/www/*
    chmod -R 755 /var/www/*
    mkdir -p /run/php/
    touch /run/php/php7.4-fpm.pid
    chown -R www-data:www-data /var/www/html/
}


load_and_verify_credentials()
{
    if [ -f /run/secrets/credentials ]; then
		source <(grep -v '^#' /run/secrets/credentials | grep 'MYSQL\|WP_' | sed 's/ //g')

    fi

    if [ -f /run/secrets/db_password ]; then
        MYSQL_PASSWORD=$(cat /run/secrets/db_password)
    fi

    REQUIRED_VARS=("MYSQL_DATABASE" "MYSQL_USER" "MYSQL_PASSWORD" "WP_ADMIN_LOGIN" "WP_ADMIN_EMAIL" "WP_ADMIN_PASSWORD" \
	"WP_USER_LOGIN" "WP_USER_EMAIL" "WP_USER_PASSWORD")
    for var in "${REQUIRED_VARS[@]}"; do
        if [ -z "${!var}" ]; then
            echo -e "${RED}Error: Missing required environment variable: $var${RESET}"
            exit 1
        fi
    done
}



retry_command()
{
	# $1 is the command passed to the function
    local cmd="$1"
    local max_attempts=5
    local attempt=1

    until $cmd; do
        if [ $attempt -ge $max_attempts ]; then
            echo -e "${RED}Command failed: ${cmd} (Max attempts: $max_attempts)${RESET}"
            exit 1
        fi
        echo -e "${YELLOW}Retrying the command ${cmd} ... (Attempt: $attempt/$max_attempts)${RESET}"
        attempt=$((attempt + 1))
        sleep 2
    done
}



install_wordpress()
{
    if [ ! -f /var/www/html/wp-config.php ]; then
        retry_command "wp-cli core download --allow-root"
        retry_command "wp-cli config create --allow-root --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb"
        retry_command "wp-cli core install --allow-root --url=$DOMAIN_NAME --title='wordpress' --admin_user=$WP_ADMIN_LOGIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL"
        retry_command "wp-cli user create --allow-root $WP_USER_LOGIN $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD"
        echo -e "${GREEN}WordPress installation completed successfully.${RESET}"
    else
        echo -e "${GREEN}WordPress is already installed. You can visit $DOMAIN_NAME in your browser. ${RESET}"
    fi
}


prepare_environment
load_and_verify_credentials
install_wordpress
exec "$@"


