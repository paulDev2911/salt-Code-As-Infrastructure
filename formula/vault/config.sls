vault_repo_gpg:
  file.managed:
    - name: /usr/share/keyrings/hashicorp-archive-keyring.gpg
    - source: https://apt.releases.hashicorp.com/gpg
    - source_hash: false
    - skip_verify: true

vault_repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/hashicorp.list
    - require:
      - file: vault_repo_gpg

vault_pkg:
  pkg.installed:
    - name: vault
    - require:
      - pkgrepo: vault_repo