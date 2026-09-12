#!/bin/sh
set -e

# 默认参数兜底
API_URL=${API_URL:-"http://localhost:50005/"}
BACKEND=${BACKEND:-"nftables"}
LOG_LEVEL=${LOG_LEVEL:-"info"}

if [ -z "$API_KEY" ]; then
    echo "[FATAL] API_KEY is required but not set!" >&2
    exit 1
fi

mkdir -p /etc/crowdsec/bouncers/

# 纯内存动态生成极简配置文件
cat << EOF > /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
api_url: ${API_URL}
api_key: ${API_KEY}
backend: ${BACKEND}
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

# 将进程替换为原生 bouncer（保持 PID 为 1，支持优雅退出）
exec /usr/local/bin/crowdsec-firewall-bouncer -c /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
