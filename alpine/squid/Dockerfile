# docker build -t songdongsheng/squid .

FROM alpine
RUN apk update && apk upgrade && apk add squid curl \
    && curl -sSL -o /etc/squid/squid.conf https://raw.githubusercontent.com/songdongsheng/docker-image/master/alpine/squid/squid.conf \
    && apk del curl && rm -rf /var/cache/apk/* \
    && mkdir -p /var/spool/squid /var/log/squid \
    && chown -R squid:squid /var/log/squid /var/spool/squid \
    && /usr/sbin/squid -N -C -f /etc/squid/squid.conf -z

# COPY squid.conf /etc/squid/squid.conf
EXPOSE 3128/tcp
ENTRYPOINT ["/usr/sbin/squid", "-N", "-Y", "-C", "-d", "1" ]
