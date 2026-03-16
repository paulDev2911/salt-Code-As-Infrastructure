base:
  '*':
    - common.users
    - common.ssh
    - common.fail2ban
  'role:vault':
    - match: grain
    - vault