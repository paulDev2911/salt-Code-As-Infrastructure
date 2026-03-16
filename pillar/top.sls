base:
  '*':
    - common.users
    - common.ssh
    - common.fail2ban
    - common.sysctl
  'role:vault':
    - match: grain
    - vault