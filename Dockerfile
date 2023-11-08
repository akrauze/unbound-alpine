ARG ALPINE_VERSION=edge
FROM alpine:${ALPINE_VERSION}

LABEL org.opencontainers.image.source=https://github.com/akrauze/unbound-alpine
LABEL org.opencontainers.image.description="Unbound on Alpine Edge"
LABEL org.opencontainers.image.licenses=MIT

ARG UNBOUND_VERSION=1.18.0-r0
ENV UNBOUND_PORT=53

RUN apk update && apk add --no-cache unbound=$UNBOUND_VERSION curl drill ca-certificates \
    && curl -L https://www.internic.net/domain/named.cache -o /etc/unbound/root.hints  \
    && chmod -R 775 /etc/unbound \
    && chown -R root:unbound /etc/unbound

EXPOSE 53/tcp
EXPOSE 53/udp

HEALTHCHECK --interval=10s --timeout=10s --start-period=10s --retries=3 CMD drill -p $UNBOUND_PORT @127.0.0.1 www.google.com || exit 1
RUN date
CMD ["unbound",  "-d"]
