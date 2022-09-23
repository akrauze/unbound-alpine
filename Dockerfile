FROM alpine:edge

RUN apk add --no-cache unbound curl drill ca-certificates \
    && curl -L https://www.internic.net/domain/named.cache -o /etc/unbound/root.hints  \
    && chmod -R 775 /etc/unbound \
    && chown -R root:unbound /etc/unbound

EXPOSE 53/tcp
EXPOSE 53/udp

CMD ["unbound",  "-d"]
