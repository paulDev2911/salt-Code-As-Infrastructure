{% from "unattended-upgrades/map.jinja" import unattended_upgrades with context %}

unattended_upgrades_periodic_config:
  file.managed:
    - name: /etc/apt/apt.conf.d/20auto-upgrades
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        APT::Periodic::Update-Package-Lists "{{ unattended_upgrades.update_package_lists }}";
        APT::Periodic::Unattended-Upgrade "{{ unattended_upgrades.unattended_upgrade }}";
        APT::Periodic::Download-Upgradeable-Packages "{{ unattended_upgrades.download_upgradeable }}";
        APT::Periodic::AutocleanInterval "{{ unattended_upgrades.autoclean_interval }}";
    - require:
      - pkg: unattended_upgrades_pkg

unattended_upgrades_main_config:
  file.managed:
    - name: /etc/apt/apt.conf.d/50unattended-upgrades
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        Unattended-Upgrade::Allowed-Origins {
        {% for origin in unattended_upgrades.allowed_origins %}
            "{{ origin }}";
        {% endfor %}
        };

        Unattended-Upgrade::Package-Blacklist {
        {% for pkg in unattended_upgrades.package_blacklist %}
            "{{ pkg }}";
        {% endfor %}
        };

        Unattended-Upgrade::AutoFixInterruptedDpkg "{{ unattended_upgrades.auto_fix_interrupted_dpkg | lower }}";
        Unattended-Upgrade::MinimalSteps "{{ unattended_upgrades.minimal_steps | lower }}";
        Unattended-Upgrade::Remove-Unused-Dependencies "{{ unattended_upgrades.remove_unused_dependencies | lower }}";
        Unattended-Upgrade::Remove-New-Unused-Dependencies "{{ unattended_upgrades.remove_new_unused_dependencies | lower }}";

        Unattended-Upgrade::Automatic-Reboot "{{ unattended_upgrades.automatic_reboot | lower }}";
        Unattended-Upgrade::Automatic-Reboot-Time "{{ unattended_upgrades.automatic_reboot_time }}";
        Unattended-Upgrade::Automatic-Reboot-WithUsers "{{ unattended_upgrades.automatic_reboot_with_users | lower }}";

        Unattended-Upgrade::SyslogEnable "{{ unattended_upgrades.syslog_enable | lower }}";
        Unattended-Upgrade::SyslogFacility "{{ unattended_upgrades.syslog_facility }}";

        {% if unattended_upgrades.mail %}
        Unattended-Upgrade::Mail "{{ unattended_upgrades.mail }}";
        Unattended-Upgrade::MailReport "{{ unattended_upgrades.mail_report }}";
        {% endif %}
    - require:
      - pkg: unattended_upgrades_pkg
