#!/bin/sh
set -e

API_URL=${API_URL:-"http://localhost:50005/"}
MODE=${MODE:-"nftables"}
LOG_LEVEL=${LOG_LEVEL:-"info"}

if [ -z "$API_KEY" ]; then
    echo "[FATAL] API_KEY is required but not set!" >&2
    exit 1
fi

mkdir -p /etc/crowdsec/bouncers/

cat << EOF > /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
mode: ${MODE}
api_url: ${API_URL}
api_key: ${API_KEY}
log_level: ${LOG_LEVEL}
log_media: stdout
nftables:
  ipv4:
    enabled: true
    set-only: false
    table: crowdsec
    chain: crowdsec_chain
  ipv6:
    enabled: true
    set-only: false
    table: crowdsec6
    chain: crowdsec6_chain
EOF

exec /usr/local/bin/crowdsec-firewall-bouncer -c /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
