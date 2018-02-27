FROM quay.io/thwint/alpine-base:3.7-0

LABEL maintainer="Tom Winterhalder <tom.winterhalder@gmail.com>"

ADD *.sh /
ADD named.conf.tmpl /etc/bind/named.conf.tmpl

RUN apk add --no-cache bind && \
    curl -SL https://github.com/jwilder/dockerize/releases/download/v0.6.0/dockerize-alpine-linux-amd64-v0.6.0.tar.gz | tar xzC /usr/local/bin &&\
    rm -rf /var/cache/dpk/* && \
    chmod +x /*.sh

EXPOSE 53/tcp 53/udp

HEALTHCHECK --interval=1m CMD /healthcheck.sh || exit 1

CMD ["/start.sh"]
