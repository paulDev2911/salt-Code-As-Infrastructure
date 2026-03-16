vault_repo_gpg:
  cmd.run:
    - name: curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    - creates: /usr/share/keyrings/hashicorp-archive-keyring.gpg

vault_repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/hashicorp.list
    - require:
      - cmd: vault_repo_gpg

vault_pkg:
  pkg.installed:
    - name: vault
    - require:
      - pkgrepo: vault_repo