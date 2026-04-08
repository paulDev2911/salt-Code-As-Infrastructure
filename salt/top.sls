base:
  '*':
    - users
    - ssh
    - fail2ban
    - sysctl
    - unattended-upgrades
  'role:vault':
    - match: grain
    - vault
  'media':
    - navidrome
    - jellyfin
  'vault':
    - vaultwarden