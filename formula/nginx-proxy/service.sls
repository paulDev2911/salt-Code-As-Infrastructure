nginx_proxy_service:
  service.running:
    - name: nginx
    - enable: true
    - watch:
      - file: /etc/nginx/sites-available
    - require:
      - pkg: nginx_proxy_pkg