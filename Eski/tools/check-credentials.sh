#!/bin/bash

GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

SECRETS_PATH='/home/acosgun/Masaüstü/Inception_github/secrets'

#db_password check

if [ -f ${SECRETS_PATH}/db_password.txt ] && [ ! -z "$(cat ${SECRETS_PATH}/db_password.txt)" ]; then
    export MYSQL_PASSWORD=$(cat ${SECRETS_PATH}/db_password.txt)
else
    echo -e "${RED}db_password secret file is missing OR empty !${RESET}"
    exit 1
fi

#db_root_password check

if [ -f ${SECRETS_PATH}/db_root_password.txt ] && [ ! -z "$(cat ${SECRETS_PATH}/db_root_password.txt)" ]; then
    export MYSQL_ROOT_PASSWORD=$(cat ${SECRETS_PATH}/db_root_password.txt)
else
    echo -e "${RED}db_root_password secret file is missing OR empty !${RESET}"
    exit 1
fi


#credentials file check

if [ ! -f ${SECRETS_PATH}/credentials.txt ]; then
    echo -e "${RED}credentials file is missing !${RESET}"
    exit 1
fi


#credential variables check

MYSQL_USER=$(grep MYSQL_USER ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
MYSQL_DATABASE=$(grep MYSQL_DATABASE ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
WP_ADMIN_LOGIN=$(grep WP_ADMIN_LOGIN ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
WP_ADMIN_PASSWORD=$(grep WP_ADMIN_PASSWORD ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
WP_ADMIN_EMAIL=$(grep WP_ADMIN_EMAIL ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
MAIL_EXTENTION=$(grep MAIL_EXTENTION ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
WP_USER_LOGIN=$(grep WP_USER_LOGIN ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
WP_USER_PASSWORD=$(grep WP_USER_PASSWORD ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
WP_USER_EMAIL=$(grep WP_USER_EMAIL ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
SUBJ=$(grep SUBJ ${SECRETS_PATH}/credentials.txt | awk -F '=' '{sub(/^ +| +$/, "", $2); print substr($0, index($0, $2))}')
CRT=$(grep -E '^CRT=' ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
CRT_KEY=$(grep -E '^CRT_KEY=' ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')	

if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$WP_ADMIN_LOGIN" ] || [ -z "$WP_ADMIN_PASSWORD" ] || \
    [ -z "$WP_ADMIN_EMAIL" ] || [ -z "$MAIL_EXTENTION" ] || [ -z "$WP_USER_LOGIN" ] || [ -z "$WP_USER_PASSWORD" ] || \
    [ -z "$WP_USER_EMAIL" ] || [ -z "$SUBJ" ] || [ -z "$CRT" ] || [ -z "$CRT_KEY" ]; then
    echo -e "${RED}Some credential variables are not set !${RESET}"
    exit 1
fi

echo "SUBJ = ${SUBJ}"
echo -e "${GREEN} All credential variables are available...${RESET}"