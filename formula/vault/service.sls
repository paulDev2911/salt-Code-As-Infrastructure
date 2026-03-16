vault_service:
  service.running:
    - name: vault
    - enable: true
    - watch:
      - file: vault_config