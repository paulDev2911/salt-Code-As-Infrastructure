fail2ban_service:
  service.running:
    - name: fail2ban
    - enable: true
    - watch:
      - file: fail2ban_config
      - file: fail2ban_jail_config
