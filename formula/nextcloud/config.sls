{% from "nextcloud/map.jinja" import nextcloud with context %}

nextcloud_nginx_config:
  file.managed:
    - name: /etc/nginx/sites-available/nextcloud
    - mode: '0644'
    - contents: |
        upstream php-handler {
            server unix:/run/php/php{{ nextcloud.php_version }}-fpm.sock;
        }
        server {
            listen 80;
            server_name {{ nextcloud.domain }};
            root /var/www/nextcloud;
            index index.php index.html;

            client_max_body_size 16G;
            fastcgi_buffers 64 4K;

            location / {
                try_files $uri $uri/ /index.php$request_uri;
            }

            location ~ \.php(?:$|/) {
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                fastcgi_pass php-handler;
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_param modHeadersAvailable true;
                fastcgi_param front_controller_active true;
                fastcgi_intercept_errors on;
                fastcgi_request_buffering off;
            }

            location ~* \.(?:css|js|woff|svg|gif|png|html|ttf|ico|jpg|jpeg)$ {
                try_files $uri /index.php$request_uri;
                expires 6M;
                access_log off;
            }
        }
    - require:
      - pkg: nextcloud_nginx

nextcloud_nginx_enable:
  file.symlink:
    - name: /etc/nginx/sites-enabled/nextcloud
    - target: /etc/nginx/sites-available/nextcloud
    - require:
      - file: nextcloud_nginx_config

nextcloud_nginx_default_disable:
  file.absent:
    - name: /etc/nginx/sites-enabled/default

nextcloud_install_cmd:
  cmd.run:
    - name: |
        sudo -u www-data php /var/www/nextcloud/occ maintenance:install \
          --database pgsql \
          --database-name {{ nextcloud.db_name }} \
          --database-user {{ nextcloud.db_user }} \
          --database-pass {{ nextcloud.db_password }} \
          --admin-user {{ nextcloud.admin_user }} \
          --admin-pass {{ nextcloud.admin_password }} \
          --data-dir {{ nextcloud.data_dir }}
    - creates: /var/www/nextcloud/config/config.php
    - require:
      - cmd: nextcloud_download
      - service: nextcloud_postgresql_service
      - service: nextcloud_php_fpm_service

nextcloud_redis_config_nc:
  cmd.run:
    - name: |
        sudo -u www-data php /var/www/nextcloud/occ config:system:set redis host --value="127.0.0.1" && \
        sudo -u www-data php /var/www/nextcloud/occ config:system:set redis port --value=6379 --type=integer && \
        sudo -u www-data php /var/www/nextcloud/occ config:system:set redis password --value="{{ nextcloud.redis_password }}" && \
        sudo -u www-data php /var/www/nextcloud/occ config:system:set memcache.local --value="\OC\Memcache\APCu" && \
        sudo -u www-data php /var/www/nextcloud/occ config:system:set memcache.distributed --value="\OC\Memcache\Redis" && \
        sudo -u www-data php /var/www/nextcloud/occ config:system:set memcache.locking --value="\OC\Memcache\Redis"
    - onchanges:
      - cmd: nextcloud_install_cmd
    - require:
      - service: nextcloud_redis_service