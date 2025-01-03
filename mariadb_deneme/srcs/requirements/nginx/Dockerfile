FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -new -x509 -nodes -out /etc/nginx/ssl/nginx.crt -keyout /etc/nginx/ssl/nginx.key -days 365 -subj "/CN=localhost"

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
