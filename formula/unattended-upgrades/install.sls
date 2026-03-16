unattended_upgrades_pkg:
  pkg.installed:
    - pkgs:
      - unattended-upgrades
      - apt-listchanges
