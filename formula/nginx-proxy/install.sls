nginx_proxy_pkg:
  pkg.installed:
    - name: nginx

nginx_proxy_default_disable:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx_proxy_pkg