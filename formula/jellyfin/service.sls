jellyfin_service:
  service.running:
    - name: jellyfin
    - enable: true
    - watch:
      - pkg: jellyfin_pkg
    - require:
      - pkg: jellyfin_pkg