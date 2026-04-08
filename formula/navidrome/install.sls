{% from "navidrome/map.jinja" import navidrome with context %}

navidrome_deps:
  pkg.installed:
    - pkgs:
      - ffmpeg
      - curl

navidrome_group:
  group.present:
    - name: {{ navidrome.group }}

navidrome_user:
  user.present:
    - name: {{ navidrome.user }}
    - gid: {{ navidrome.group }}
    - home: {{ navidrome.data_folder }}
    - shell: /usr/sbin/nologin
    - system: true
    - require:
      - group: navidrome_group

navidrome_data_dir:
  file.directory:
    - name: {{ navidrome.data_folder }}
    - user: {{ navidrome.user }}
    - group: {{ navidrome.group }}
    - mode: '0750'
    - require:
      - user: navidrome_user

navidrome_binary:
  cmd.run:
    - name: |
        curl -fsSL https://github.com/navidrome/navidrome/releases/download/v{{ navidrome.version }}/navidrome_{{ navidrome.version }}_linux_amd64.tar.gz \
          -o /tmp/navidrome.tar.gz && \
        tar -xzf /tmp/navidrome.tar.gz -C /usr/local/bin navidrome && \
        chmod +x /usr/local/bin/navidrome && \
        rm /tmp/navidrome.tar.gz
    - unless: test -f /usr/local/bin/navidrome && /usr/local/bin/navidrome --version 2>&1 | grep -q {{ navidrome.version }}
    - require:
      - pkg: navidrome_deps
