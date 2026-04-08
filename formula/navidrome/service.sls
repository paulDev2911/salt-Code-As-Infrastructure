{% from "navidrome/map.jinja" import navidrome with context %}

navidrome_systemd:
  file.managed:
    - name: /etc/systemd/system/navidrome.service
    - mode: '0644'
    - contents: |
        [Unit]
        Description=Navidrome Music Server
        After=network.target

        [Service]
        User={{ navidrome.user }}
        Group={{ navidrome.group }}
        ExecStart=/usr/local/bin/navidrome --configfile /etc/navidrome/navidrome.toml
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
    - require:
      - file: navidrome_config

navidrome_service:
  service.running:
    - name: navidrome
    - enable: true
    - watch:
      - file: navidrome_config
      - file: navidrome_systemd
    - require:
      - cmd: navidrome_binary
      - file: navidrome_systemd
