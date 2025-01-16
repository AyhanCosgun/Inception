#!/bin/bash

GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'


# Prepare certificate  variables
if [ -f /run/secrets/credentials ]; then
    source <(grep -v '^#' /run/secrets/credentials | grep 'CERT' | sed 's/ //g')	
else
    echo -e "${RED}credentials file is missing !${RESET}"
	exit 1
fi

if [ -z "$SUBJ" ] || [ -z "$CERT_PATH" ] || [ -z "$CERT_KEY" ]; then
	echo -e "${RED}credentials file is empty !${RESET}"
	exit 1
fi

# Create SSL certificate
if [ ! -f $CERT_PATH ]; then
    openssl req -x509 -sha256 -nodes \
	-newkey rsa:4096 \
	-days 365 \
	-subj "$SUBJ" \
	-keyout $CERT_KEY \
	-out $CERT_PATH
else
	echo -e "${CYAN}Certificate is ready ...${RESET}"
fi

# Update CERT key and path in configuration file https.conf
sed -i "s|!CERT_KEY_PLACEHOLDER!|${CERT_KEY}|g" /etc/nginx/conf.d/https.conf
sed -i "s|!CERT_PATH_PLACEHOLDER!|${CERT_PATH}|g" /etc/nginx/conf.d/https.conf

echo -e "${GREEN}SSL settings are done, nginx is ready ...${RESET}"

exec "$@"

