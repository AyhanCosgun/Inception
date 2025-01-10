FROM debian:bullseye

RUN apt-get -y update && apt-get -y install nginx openssl 

COPY ./conf/https.conf /etc/nginx/conf.d/

COPY ./tools/setup-nginx.sh /
RUN chmod +x /setup-nginx.sh
ENTRYPOINT	[ "/setup-nginx.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]
