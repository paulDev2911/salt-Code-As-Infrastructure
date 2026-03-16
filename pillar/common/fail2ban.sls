fail2ban:
  bantime: 3600
  maxretry: 5
  jails:
    sshd:
      enabled: true
      port: ssh
      filter: sshd
      logpath: /var/log/auth.log
      maxretry: 3
