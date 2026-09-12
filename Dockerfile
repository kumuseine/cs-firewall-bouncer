FROM alpine:latest

# 只安装必要的内核防火墙命令行和 TLS 根证书
RUN apk add --no-cache ca-certificates nftables tzdata && \
    # 使用 Alpine 自带的 wget 直接拉取官方最新 amd64 预编译静态二进制
    wget -qO- https://github.com/crowdsecurity/cs-firewall-bouncer/releases/latest/download/crowdsec-firewall-bouncer-linux-amd64.tgz \
    | tar -xz -C /tmp && \
    mv /tmp/crowdsec-firewall-bouncer-*/crowdsec-firewall-bouncer /usr/local/bin/ && \
    rm -rf /tmp/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
