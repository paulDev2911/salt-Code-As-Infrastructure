{% from "vault/map.jinja" import vault with context %}

vault_data_dir:
  file.directory:
    - name: {{ vault.storage_path }}
    - user: vault
    - group: vault
    - mode: '0750'
    - makedirs: true
    - require:
      - pkg: vault_pkg

vault_config:
  file.serialize:
    - name: /etc/vault.d/vault.hcl
    - user: vault
    - group: vault
    - mode: '0640'
    - formatter: json
    - dataset:
        ui: {{ vault.ui }}
        disable_mlock: {{ vault.get('disable_mlock', false) }}
        storage:
          file:
            path: {{ vault.storage_path }}
        listener:
          tcp:
            address: {{ vault.listen_address }}
            tls_disable: {{ vault.tls_disable | int }}
        api_addr: "http://{{ vault.listen_address }}"
    - require:
      - pkg: vault_pkg