{% from "navidrome/map.jinja" import navidrome with context %}

navidrome_config:
  file.managed:
    - name: /etc/navidrome/navidrome.toml
    - user: {{ navidrome.user }}
    - group: {{ navidrome.group }}
    - mode: '0640'
    - makedirs: true
    - contents: |
        MusicFolder = "{{ navidrome.music_folder }}"
        DataFolder   = "{{ navidrome.data_folder }}"
        Address      = "0.0.0.0"
        Port         = 4533
        LogLevel     = "{{ navidrome.log_level }}"
    - require:
      - user: navidrome_user