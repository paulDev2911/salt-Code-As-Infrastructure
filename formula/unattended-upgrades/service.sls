# Ensure systemd timers are active so upgrades actually run on schedule
unattended_upgrades_apt_daily_timer:
  service.running:
    - name: apt-daily.timer
    - enable: true
    - require:
      - pkg: unattended_upgrades_pkg

unattended_upgrades_apt_daily_upgrade_timer:
  service.running:
    - name: apt-daily-upgrade.timer
    - enable: true
    - watch:
      - file: unattended_upgrades_main_config
      - file: unattended_upgrades_periodic_config
    - require:
      - pkg: unattended_upgrades_pkg
