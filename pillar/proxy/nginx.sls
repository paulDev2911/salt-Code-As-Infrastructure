nginx_proxy:
  proxies:
    jellyfin:
      domain: jellyfin.home
      upstream: 192.168.2.101:8096
      max_body_size: 10M

    navidrome:
      domain: navidrome.home
      upstream: 192.168.2.101:4533

    nextcloud:
      domain: nextcloud.home
      upstream: 192.168.2.102:80
      max_body_size: 16G

    vaultwarden:
      domain: vaultwarden.home
      upstream: 192.168.2.103:8080