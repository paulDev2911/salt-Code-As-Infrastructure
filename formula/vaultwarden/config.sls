{% from "vaultwarden/map.jinja" import vaultwarden with context %}

vaultwarden_config:
  file.managed:
    - name: /etc/vaultwarden.env
    - user: vaultwarden
    - group: vaultwarden
    - mode: '0640'
    - contents: |
        DATA_FOLDER={{ vaultwarden.data_folder }}
        DOMAIN={{ vaultwarden.domain }}
        ROCKET_PORT={{ vaultwarden.port }}
        SIGNUPS_ALLOWED={{ vaultwarden.signups_allowed | upper }}
        ADMIN_TOKEN={{ vaultwarden.admin_token }}
        WEBSOCKET_ENABLED=true
    - require:
      - pkg: vaultwarden_pkg