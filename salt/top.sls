base:
  '*':
    - users
    - ssh
    - fail2ban
  'role:vault':
    - match: grain
    - vault