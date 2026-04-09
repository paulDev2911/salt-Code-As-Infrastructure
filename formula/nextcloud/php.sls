{% from "nextcloud/map.jinja" import nextcloud with context %}

nextcloud_php_ini:
  file.managed:
    - name: /etc/php/{{ nextcloud.php_version }}/fpm/conf.d/99-nextcloud.ini
    - mode: '0644'
    - contents: |
        memory_limit = 512M
        upload_max_filesize = 16G
        post_max_size = 16G
        max_execution_time = 360
        date.timezone = Europe/Berlin
        opcache.enable = 1
        opcache.memory_consumption = 128
        opcache.interned_strings_buffer = 8
        opcache.max_accelerated_files = 10000
        opcache.revalidate_freq = 1
        opcache.save_comments = 1
    - require:
      - pkg: nextcloud_php_pkgs

nextcloud_php_fpm_service:
  service.running:
    - name: php{{ nextcloud.php_version }}-fpm
    - enable: true
    - watch:
      - file: nextcloud_php_ini