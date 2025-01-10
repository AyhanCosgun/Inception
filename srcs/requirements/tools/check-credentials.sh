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

# if [ -f ${SECRETS_PATH}/credentials.txt ]; then
# 		source <(grep -v '^#' ${SECRETS_PATH}/credentials.txt | sed 's/ //g')
# else
#     echo -e "${RED}credentials file is missing !${RESET}"
#     exit 1
# fi

#if [ ! -f ${SECRETS_PATH}/credentials.txt ]; then
 #   echo -e "${RED}credentials file is missing !${RESET}"
  #  exit 1
#fi


#credential variables check

# REQUIRED_VARS=("MYSQL_DATABASE" "MYSQL_USER" "MYSQL_PASSWORD" "WP_ADMIN_LOGIN" "WP_ADMIN_EMAIL" "WP_ADMIN_PASSWORD" \
# 	"WP_USER_LOGIN" "WP_USER_EMAIL" "WP_USER_PASSWORD")
# for var in "${REQUIRED_VARS[@]}"; do
#     if [ -z "${!var}" ]; then
#          echo -e "${RED}Error: Missing required environment variable: $var${RESET}"
#         exit 1
#     fi
# done

#MYSQL_USER=$(grep MYSQL_USER ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#MYSQL_DATABASE=$(grep MYSQL_DATABASE ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#WP_ADMIN_LOGIN=$(grep WP_ADMIN_LOGIN ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#WP_ADMIN_PASSWORD=$(grep WP_ADMIN_PASSWORD ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#WP_ADMIN_EMAIL=$(grep WP_ADMIN_EMAIL ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#WP_USER_LOGIN=$(grep WP_USER_LOGIN ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#WP_USER_PASSWORD=$(grep WP_USER_PASSWORD ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#WP_USER_EMAIL=$(grep WP_USER_EMAIL ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#SUBJ=$(grep -E '^SUBJ=' ${SECRETS_PATH}/credentials.txt | awk -F '=' '{print substr($0, index($0,$2))}' | tr -d '[:space:]')
#CERT_PATH=$(grep -E '^CERT_PATH=' ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')
#CERT_KEY=$(grep -E '^CERT_KEY=' ${SECRETS_PATH}/credentials.txt | cut -d '=' -f2 | tr -d '[:space:]')	

#if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$WP_ADMIN_LOGIN" ] || [ -z "$WP_ADMIN_PASSWORD" ] || \
 #   [ -z "$WP_ADMIN_EMAIL" ] || [ -z "$WP_USER_LOGIN" ] || [ -z "$WP_USER_PASSWORD" ] || \
  #  [ -z "$WP_USER_EMAIL" ] || [ -z "$SUBJ" ] || [ -z "$CERT_PATH" ] || [ -z "$CERT_KEY" ]; then
  #  echo -e "${RED}Some credential variables are not set !${RESET}"
  #  exit 1
#fi


if [ -f ${SECRETS_PATH}/credentials.txt ]; then
    source <(grep -v '^#' ${SECRETS_PATH}/credentials.txt | grep 'SUBJ\|CERT' | sed 's/ //g')	
else
    echo -e "${RED}Credentials secret file not found, didn't get information for SSL.${RESET}"
	exit 1
fi


echo "SUBJ = ${SUBJ}"
echo "CERT_KEY = ${CERT_KEY}"
echo "CERT_PATH = ${CERT_PATH}"


echo -e "${GREEN} All credential variables are available...${RESET}"