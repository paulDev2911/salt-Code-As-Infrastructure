nginx_proxy_service:
  service.running:
    - name: nginx
    - enable: true
    - require:
      - pkg: nginx_proxy_pkg