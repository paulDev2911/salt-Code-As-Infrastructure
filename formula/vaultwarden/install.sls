{% from "vaultwarden/map.jinja" import vaultwarden with context %}

vaultwarden_deps:
  pkg.installed:
    - pkgs:
      - curl
      - python3

vaultwarden_extractor:
  cmd.run:
    - name: |
        curl -fsSL https://raw.githubusercontent.com/jjlin/docker-image-extract/main/docker-image-extract \
          -o /tmp/docker-image-extract && \
        chmod +x /tmp/docker-image-extract
    - creates: /tmp/docker-image-extract
    - require:
      - pkg: vaultwarden_deps

vaultwarden_extract:
  cmd.run:
    - name: |
        cd /tmp && \
        mkdir -p vaultwarden-extract && \
        cd vaultwarden-extract && \
        /tmp/docker-image-extract vaultwarden/server:alpine && \
        cp output/vaultwarden /usr/local/bin/vaultwarden && \
        chmod +x /usr/local/bin/vaultwarden && \
        mkdir -p {{ vaultwarden.data_folder }}/web-vault && \
        cp -r output/web-vault/* {{ vaultwarden.data_folder }}/web-vault/ && \
        rm -rf /tmp/vaultwarden-extract
    - creates: /usr/local/bin/vaultwarden

vaultwarden_group:
  group.present:
    - name: vaultwarden

vaultwarden_user:
  user.present:
    - name: vaultwarden
    - gid: vaultwarden
    - home: {{ vaultwarden.data_folder }}
    - shell: /usr/sbin/nologin
    - system: true
    - require:
      - group: vaultwarden_group

vaultwarden_data_dir:
  file.directory:
    - name: {{ vaultwarden.data_folder }}/data
    - user: vaultwarden
    - group: vaultwarden
    - mode: '0750'
    - makedirs: true
    - require:
      - user: vaultwarden_user