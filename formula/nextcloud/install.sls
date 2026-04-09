{% from "nextcloud/map.jinja" import nextcloud with context %}

nextcloud_deps:
  pkg.installed:
    - pkgs:
      - curl
      - gnupg
      - apt-transport-https
      - ca-certificates
      - unzip
      - ffmpeg

nextcloud_php_repo_gpg:
  cmd.run:
    - name: |
        curl -fsSL https://packages.sury.org/php/apt.gpg \
          | gpg --dearmor -o /usr/share/keyrings/php-sury.gpg
    - creates: /usr/share/keyrings/php-sury.gpg
    - require:
      - pkg: nextcloud_deps

nextcloud_php_repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/php-sury.gpg] https://packages.sury.org/php bookworm main
    - file: /etc/apt/sources.list.d/php-sury.list
    - require:
      - cmd: nextcloud_php_repo_gpg

nextcloud_php_pkgs:
  pkg.installed:
    - pkgs:
      - php{{ nextcloud.php_version }}-fpm
      - php{{ nextcloud.php_version }}-cli
      - php{{ nextcloud.php_version }}-curl
      - php{{ nextcloud.php_version }}-gd
      - php{{ nextcloud.php_version }}-mbstring
      - php{{ nextcloud.php_version }}-xml
      - php{{ nextcloud.php_version }}-zip
      - php{{ nextcloud.php_version }}-pgsql
      - php{{ nextcloud.php_version }}-intl
      - php{{ nextcloud.php_version }}-bcmath
      - php{{ nextcloud.php_version }}-gmp
      - php{{ nextcloud.php_version }}-imagick
      - php{{ nextcloud.php_version }}-redis
      - php{{ nextcloud.php_version }}-apcu
    - require:
      - pkgrepo: nextcloud_php_repo

nextcloud_nginx:
  pkg.installed:
    - name: nginx

nextcloud_download:
  cmd.run:
    - name: |
        curl -fsSL https://download.nextcloud.com/server/releases/latest-{{ nextcloud.version }}.zip \
          -o /tmp/nextcloud.zip && \
        unzip -q /tmp/nextcloud.zip -d /var/www/ && \
        rm /tmp/nextcloud.zip && \
        chown -R www-data:www-data /var/www/nextcloud
    - creates: /var/www/nextcloud/index.php
    - require:
      - pkg: nextcloud_php_pkgs
      - pkg: nextcloud_nginx

nextcloud_data_dir:
  file.directory:
    - name: {{ nextcloud.data_dir }}
    - user: www-data
    - group: www-data
    - mode: '0750'
    - makedirs: true