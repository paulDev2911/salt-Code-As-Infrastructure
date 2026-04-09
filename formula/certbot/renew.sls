certbot_renew_timer:
  file.managed:
    - name: /etc/systemd/system/certbot-renew.timer
    - mode: '0644'
    - contents: |
        [Unit]
        Description=Certbot Renewal Timer

        [Timer]
        OnCalendar=*-*-* 03:00:00
        RandomizedDelaySec=1h
        Persistent=true

        [Install]
        WantedBy=timers.target

certbot_renew_service:
  file.managed:
    - name: /etc/systemd/system/certbot-renew.service
    - mode: '0644'
    - contents: |
        [Unit]
        Description=Certbot Renewal

        [Service]
        Type=oneshot
        ExecStart=/usr/bin/certbot renew --quiet --deploy-hook "systemctl reload nginx"

certbot_renew_timer_enabled:
  service.running:
    - name: certbot-renew.timer
    - enable: true
    - require:
      - file: certbot_renew_timer
      - file: certbot_renew_service