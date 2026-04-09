vaultwarden_service:
  service.running:
    - name: vaultwarden
    - enable: true
    - watch:
      - file: vaultwarden_config
    - require:
      - pkg: vaultwarden_pkg
      - file: vaultwarden_config