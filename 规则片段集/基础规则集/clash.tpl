# {{ downloadUrl }}

external-controller: 127.0.0.1:9090
port: 7890
socks-port: 7891
redir-port: 7892

{% if customParams.dns %}
dns:
  enable: true
  nameserver:
    - https://223.5.5.5/dns-query
  fallback:  # IP addresses who is outside CN in GEOIP will fallback here
    - https://223.6.6.6/dns-query
    - https://rubyfish.cn/dns-query
  fallback-filter:
    geoip: true  # Enable GEOIP-based fallback
    ipcidr:
      - 240.0.0.0/4
{% endif %}

proxies: {{ getClashNodes(nodeList) | json }}

proxy-groups:
- type: select
  name: 国内直连
  proxies: {{ getClashNodeNames(nodeList) | json }}
- type: select
  name: 国外代理
  proxies: {{ getClashNodeNames(nodeList) | json }}

- type: url-test
  name: HK
  proxies: {{ getClashNodeNames(nodeList) | json }}
  url: {{ proxyTestUrl }}
  interval: 1200


rules:
{{ remoteSnippets.apple.main('🚀 Proxy', '🍎 Apple', '🍎 Apple CDN', 'DIRECT', 'US') | clash }}
{{ remoteSnippets.netflix.main('🎬 Netflix') | clash }}
{{ remoteSnippets.hbo.main('🚀 Proxy') | clash }}
{{ remoteSnippets.hulu.main('🚀 Proxy') | clash }}

# LAN
- DOMAIN-SUFFIX,local,DIRECT
- IP-CIDR,127.0.0.0/8,DIRECT
- IP-CIDR,172.16.0.0/12,DIRECT
- IP-CIDR,192.168.0.0/16,DIRECT
- IP-CIDR,10.0.0.0/8,DIRECT
- IP-CIDR,100.64.0.0/10,DIRECT

# Final
- GEOIP,CN,DIRECT
- MATCH,🚀 Proxy
