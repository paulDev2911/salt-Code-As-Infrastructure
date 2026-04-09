nginx_proxy:
  proxies:
    jellyfin:
      domain: jellyfin.ilpaa.xyz
      upstream: 192.168.2.101:8096
      max_body_size: 10M

    navidrome:
      domain: navidrome.ilpaa.xyz
      upstream: 192.168.2.101:4533

    nextcloud:
      domain: nextcloud.ilpaa.xyz
      upstream: 192.168.2.102:80
      max_body_size: 16G

    vaultwarden:
      domain: vaultwarden.ilpaa.xyz
      upstream: 192.168.2.103:8080