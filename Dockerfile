FROM alpine:latest

ARG BOUNCER_VERSION
LABEL org.opencontainers.image.version="${BOUNCER_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/kumuseine/cs-firewall-bouncer"

RUN apk add --no-cache ca-certificates nftables tzdata && \
    wget -qO- "https://github.com/crowdsecurity/cs-firewall-bouncer/releases/download/${BOUNCER_VERSION}/crowdsec-firewall-bouncer-linux-amd64.tgz" \
    | tar -xz -C /tmp && \
    mv /tmp/crowdsec-firewall-bouncer-*/crowdsec-firewall-bouncer /usr/local/bin/ && \
    rm -rf /tmp/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
