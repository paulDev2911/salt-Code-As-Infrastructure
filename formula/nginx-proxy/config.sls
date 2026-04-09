{% from "nginx-proxy/map.jinja" import nginx_proxy with context %}

{% for name, proxy in nginx_proxy.get('proxies', {}).items() %}

nginx_proxy_{{ name }}_config:
  file.managed:
    - name: /etc/nginx/sites-available/{{ name }}
    - mode: '0644'
    - contents: |
        server {
            listen 80;
            server_name {{ proxy.domain }};

            client_max_body_size {{ proxy.get('max_body_size', '10M') }};

            location / {
                proxy_pass http://{{ proxy.upstream }};
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_buffering off;
                proxy_request_buffering off;
            }
        }
    - require:
      - pkg: nginx_proxy_pkg

nginx_proxy_{{ name }}_enable:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ name }}
    - target: /etc/nginx/sites-available/{{ name }}
    - require:
      - file: nginx_proxy_{{ name }}_config

{% endfor %}