{% from "vaultwarden/map.jinja" import vaultwarden with context %}

vaultwarden_systemd:
  file.managed:
    - name: /etc/systemd/system/vaultwarden.service
    - mode: '0644'
    - contents: |
        [Unit]
        Description=Vaultwarden Password Manager
        After=network.target

        [Service]
        User=vaultwarden
        Group=vaultwarden
        EnvironmentFile={{ vaultwarden.data_folder }}/.env
        ExecStart=/usr/local/bin/vaultwarden
        WorkingDirectory={{ vaultwarden.data_folder }}
        LimitNOFILE=1048576
        LimitNPROC=64
        PrivateTmp=true
        PrivateDevices=true
        ProtectHome=true
        ProtectSystem=strict
        ReadWriteDirectories={{ vaultwarden.data_folder }}
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target

vaultwarden_service:
  service.running:
    - name: vaultwarden
    - enable: true
    - watch:
      - file: vaultwarden_config
      - file: vaultwarden_systemd
    - require:
      - cmd: vaultwarden_extract
      - file: vaultwarden_systemd
      - file: vaultwarden_config