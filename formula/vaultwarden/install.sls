vaultwarden_container:
  docker_container.running:
    - name: vaultwarden
    - image: vaultwarden/server:latest
    - restart_policy: always
    - port_bindings:
      - {{ vaultwarden.port }}:80
      - {{ vaultwarden.websocket_port }}:3012
    - binds:
      - {{ vaultwarden.data_folder }}:/data
    - environment:
      - DOMAIN={{ vaultwarden.domain }}
      - SIGNUPS_ALLOWED={{ vaultwarden.signups_allowed | lower }}
      - ADMIN_TOKEN={{ vaultwarden.admin_token }}
      - WEBSOCKET_ENABLED=true
    - require:
      - file: vaultwarden_data_dir
      - service: docker_service