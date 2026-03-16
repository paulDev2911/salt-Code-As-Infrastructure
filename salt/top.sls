base:
  '*':
    - users
    - ssh
    - fail2ban
    - sysctl
  'role:vault':
    - match: grain
    - vault