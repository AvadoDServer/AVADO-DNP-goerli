FROM --platform=linux/amd64 ethereum/client-go:v1.13.5 as geth

RUN apk update && apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    nginx \
    openssl \
    supervisor \
    && rm -rf /var/cache/apk/* && rm -rf /tmp/*

# Set up nginx config
RUN mkdir -p /etc/nginx/certs/
WORKDIR /etc/nginx/certs/
# ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN wget http://iso.ava.do/my.ava.do.crt && wget http://iso.ava.do/my.ava.do.key

RUN ls -l /etc/nginx/certs/
COPY files/nginx.conf /etc/nginx
RUN mkdir -p /run/nginx

COPY ./files/supervisord.conf /etc/supervisord.conf

# Startup script
COPY ./files/start.sh /opt/start.sh
COPY ./files/reload-certs.sh /opt/reload-certs.sh
RUN chmod +x /opt/start.sh /opt/reload-certs.sh

ENTRYPOINT ["/opt/start.sh"]
