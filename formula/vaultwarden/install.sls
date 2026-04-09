{% from "vaultwarden/map.jinja" import vaultwarden with context %}

vaultwarden_pkg:
  pkg.installed:
    - name: vaultwarden

vaultwarden_data_dir:
  file.directory:
    - name: {{ vaultwarden.data_folder }}
    - user: vaultwarden
    - group: vaultwarden
    - mode: '0750'
    - makedirs: true
    - require:
      - pkg: vaultwarden_pkg