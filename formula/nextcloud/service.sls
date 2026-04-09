nextcloud_nginx_service:
  service.running:
    - name: nginx
    - enable: true
    - watch:
      - file: nextcloud_nginx_config
    - require:
      - file: nextcloud_nginx_enable