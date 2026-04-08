{% from "jellyfin/map.jinja" import jellyfin with context %}

jellyfin_deps:
  pkg.installed:
    - pkgs:
      - curl
      - gnupg
      - apt-transport-https

jellyfin_repo_gpg:
  cmd.run:
    - name: |
        curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key \
          | gpg --dearmor -o /usr/share/keyrings/jellyfin.gpg
    - creates: /usr/share/keyrings/jellyfin.gpg
    - require:
      - pkg: jellyfin_deps

jellyfin_repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/jellyfin.gpg] https://repo.jellyfin.org/debian bookworm main
    - file: /etc/apt/sources.list.d/jellyfin.list
    - require:
      - cmd: jellyfin_repo_gpg

jellyfin_pkg:
  pkg.installed:
    - name: jellyfin
    - require:
      - pkgrepo: jellyfin_repo