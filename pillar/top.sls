base:
  '*':
    - common.users
    - common.ssh
    - common.fail2ban
    - common.sysctl
    - common.unattended-upgrades
  'role:vault':
    - match: grain
    - vault
  'media':
    - media.navidrome
    - media.jellyfin
  'vault':
    - vault.vaultwarden
  'docs':
    - docs.nextcloud
  'proxy':
    - proxy.nginx
    - proxy.certbot