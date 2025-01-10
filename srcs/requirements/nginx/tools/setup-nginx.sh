#!/bin/bash

CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
RESET='\033[0m'

if [ -f /run/secrets/credentials ]; then
    source <(grep -v '^#' /run/secrets/credentials | grep 'SUBJ\|CERT' | sed 's/ //g')	
else
    echo -e "${RED}credentials file is missing !${RESET}"
	exit 1
fi

if [ -z "$SUBJ" ] || [ -z "$CERT_PATH" ] || [ -z "$CERT_KEY" ]; then
	echo -e "${RED}credentials file is empty !${RESET}"
	exit 1
fi

if [ ! -f $CERT_PATH ]; then
    openssl req -x509 -sha256 -nodes \
	-newkey rsa:4096 \
	-days 365 \
	-subj "$SUBJ" \
	-keyout $CERT_KEY \
	-out $CERT_PATH
else
	echo -e "${YELLOW}Certificate is ready ...${RESET}"
fi

# update CERT key and path in configuration file https.conf
sed -i "s|!CERTIFICATE_KEY_LOCATION!|${CERT_KEY}|g" /etc/nginx/conf.d/https.conf
sed -i "s|!CERTIFICATE_LOCATION!|${CERT_PATH}|g" /etc/nginx/conf.d/https.conf

echo -e "${GREEN}success SSL settings done, starting nginx...${RESET}"

exec "$@"

