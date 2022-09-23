# unbound DNS on Alpine Linux Edge
Unbound DNS resolver running on Alpine Linux Edge

## Versions

- ``lastest`` based on newest version of unbound available for the ``latest`` version of Alpine Linux at build time
- ``edge`` based on newest version of unbound available for the ``edge`` version of Alpine Linux at build time

## Platforms
- ``linux/amd64``
- ``linux/arm64``
- ``linux/arm/v7``

- Q: Why not more platforms
- A: Why more?

## Create macvlan network

```
docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1  -o parent=enp3s0 extnet
```
Make sure ``subnet`` and ``gateway`` match your network and ``parent`` matches your network interface (it may be ``eth0`` or something else)

## Run

```
docker run \
 --name=unbound \
 --detach=true \
 --publish=53:53/tcp \
 --publish=53:53/udp \
 --network=extnet \
 --ip=192.168.1.4 \
 --restart=unless-stopped \
 ghcr.io/akrauze/unbound-alpine:latest
```

Make sure ``ip`` is available and excluded from dhcp

### Override configuration

**You probably want to do this**

```
docker run \
 --name=unbound \
 --detach=true \
 --publish=53:53/tcp \
 --publish=53:53/udp \
 --network=extnet \
 --ip=192.168.1.4 \
 --restart=unless-stopped \
 --volume=/home/me/unbound/unbound.conf:/etc/unbound/unbound.conf \
 ghcr.io/akrauze/unbound-alpine:latest
```
On ``volume`` change ``/home/me/unbound/`` to the path you intent to have your config file on the host.

### Sample configuration

```
server:
    cache-max-ttl: 86400
    cache-min-ttl: 300
    edns-buffer-size: 1232
    interface: 0.0.0.0@53
    rrset-roundrobin: yes

    logfile: ""
    verbosity: 1

    delay-close: 10000
    do-daemonize: no
    do-not-query-localhost: no
    neg-cache-size: 4M
    qname-minimisation: yes

    access-control: 127.0.0.1/32 allow
    access-control: 192.168.0.0/16 allow
    access-control: 172.16.0.0/12 allow
    access-control: 10.0.0.0/8 allow

    deny-any: yes
    harden-algo-downgrade: yes
    harden-below-nxdomain: yes
    harden-dnssec-stripped: yes
    harden-glue: yes
    harden-large-queries: yes
    harden-referral-path: no
    harden-short-bufsize: yes
    hide-http-user-agent: no
    hide-identity: yes
    hide-version: yes
    http-user-agent: "DNS"
    identity: "DNS"
    private-address: 10.0.0.0/8
    private-address: 172.16.0.0/12
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    ratelimit: 1000
    tls-cert-bundle: /etc/ssl/certs/ca-certificates.crt
    unwanted-reply-threshold: 10000
    use-caps-for-id: yes
    val-clean-additional: yes


    incoming-num-tcp: 10
    num-queries-per-thread: 4096
    outgoing-range: 8192
    minimal-responses: yes
    prefetch: yes
    prefetch-key: yes
    serve-expired: yes
    so-reuseport: yes

    root-hints: "/etc/unbound/root.hints"

    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    do-ip6: no
    prefer-ip6: no
```
Once you are confident with your setup consider setting ``verbosity`` to ``0``

