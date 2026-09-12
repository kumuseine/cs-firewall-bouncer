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
EOF

# 等待 Agent 的 /v1/health 接口就绪，永不闪退
echo "Waiting for CrowdSec LAPI at ${API_URL} to be ready..."
until wget -q -O - "${API_URL}v1/health" > /dev/null 2>&1; do
    echo "LAPI is not ready yet, sleeping 2 seconds..."
    sleep 2
done
echo "CrowdSec LAPI is online! Starting firewall bouncer..."

exec /usr/local/bin/crowdsec-firewall-bouncer -c /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
