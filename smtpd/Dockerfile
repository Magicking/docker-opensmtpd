FROM alpine:3.3

MAINTAINER Guillaume Vincent <guillaume@oslab.fr>

RUN apk update && apk add \
    supervisor \
    openssl \
    opensmtpd \
    && rm -rf /var/cache/apk/*

VOLUME ["/etc/smtpd", "/var/spool/mail"]
EXPOSE 25 587

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
