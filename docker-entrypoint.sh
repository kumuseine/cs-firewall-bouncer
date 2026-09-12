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

# 纯粹只写必填项，防火墙规则完全继承官方默认的权威最佳实践！
cat << EOF > /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
mode: ${MODE}
api_url: ${API_URL}
api_key: ${API_KEY}
log_level: ${LOG_LEVEL}
log_media: stdout
EOF

exec /usr/local/bin/crowdsec-firewall-bouncer -c /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
