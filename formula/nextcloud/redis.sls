{% from "nextcloud/map.jinja" import nextcloud with context %}

nextcloud_redis:
  pkg.installed:
    - name: redis-server

nextcloud_redis_config:
  file.managed:
    - name: /etc/redis/redis.conf
    - mode: '0640'
    - user: redis
    - group: redis
    - contents: |
        bind 127.0.0.1
        port 6379
        requirepass {{ nextcloud.redis_password }}
        maxmemory 128mb
        maxmemory-policy allkeys-lru
    - require:
      - pkg: nextcloud_redis

nextcloud_redis_service:
  service.running:
    - name: redis-server
    - enable: true
    - watch:
      - file: nextcloud_redis_config