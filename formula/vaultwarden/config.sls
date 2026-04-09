{% from "vaultwarden/map.jinja" import vaultwarden with context %}

vaultwarden_config:
  file.managed:
    - name: {{ vaultwarden.data_folder }}/.env
    - user: vaultwarden
    - group: vaultwarden
    - mode: '0640'
    - contents: |
        DATA_FOLDER={{ vaultwarden.data_folder }}/data
        WEB_VAULT_FOLDER={{ vaultwarden.data_folder }}/web-vault
        DOMAIN={{ vaultwarden.domain }}
        ROCKET_PORT={{ vaultwarden.port }}
        SIGNUPS_ALLOWED={{ vaultwarden.signups_allowed | lower }}
        ADMIN_TOKEN={{ vaultwarden.admin_token }}
        WEBSOCKET_ENABLED=true
    - require:
      - user: vaultwarden_user