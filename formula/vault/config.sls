{% from "vault/map.jinja" import defaults with context %}
{% set vault = salt['pillar.get']('vault', {}) %}

vault_data_dir:
  file.directory:
    - name: {{ vault.get('storage_path', defaults.storage_path) }}
    - user: vault
    - group: vault
    - mode: '0750'
    - makedirs: true

vault_config:
  file.managed:
    - name: /etc/vault.d/vault.hcl
    - mode: '0640'
    - user: vault
    - group: vault
    - contents: |
        ui = {{ vault.get('ui', defaults.ui) | lower }}

        storage "file" {
          path = "{{ vault.get('storage_path', defaults.storage_path) }}"
        }

        listener "tcp" {
          address     = "{{ vault.get('listen_address', defaults.listen_address) }}"
          tls_disable = {{ vault.get('tls_disable', defaults.tls_disable) | int }}
        }

        api_addr = "http://{{ vault.get('listen_address', defaults.listen_address) }}"
    - require:
      - pkg: vault_pkg