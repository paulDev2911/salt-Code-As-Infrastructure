base:
  '*':
    - users
    - ssh
  'role:vault':
    - match: grain
    - vault