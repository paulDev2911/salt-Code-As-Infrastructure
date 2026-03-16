unattended_upgrades:
  # Security-only: no regular upgrades
  allowed_origins:
    - "${distro_id}:${distro_codename}-security"
    - "${distro_id}ESMApps:${distro_codename}-apps-security"
    - "${distro_id}ESM:${distro_codename}-infra-security"

  # Do not auto-reboot unless explicitly overridden per host
  automatic_reboot: false
  automatic_reboot_with_users: false

  # Reduce attack surface by removing unneeded packages
  remove_unused_dependencies: true
  remove_new_unused_dependencies: true

  # Log everything
  syslog_enable: true
