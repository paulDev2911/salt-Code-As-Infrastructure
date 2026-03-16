base:
  '*':
    - common.users
    - common.ssh
  'role:vault':
    - match: grain
    - vault