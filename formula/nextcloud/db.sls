{% from "nextcloud/map.jinja" import nextcloud with context %}

nextcloud_postgresql:
  pkg.installed:
    - pkgs:
      - postgresql
      - python3-psycopg2

nextcloud_postgresql_service:
  service.running:
    - name: postgresql
    - enable: true
    - require:
      - pkg: nextcloud_postgresql

nextcloud_db_user:
  cmd.run:
    - name: |
        sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='{{ nextcloud.db_user }}'" | grep -q 1 || \
        sudo -u postgres psql -c "CREATE USER {{ nextcloud.db_user }} WITH PASSWORD '{{ nextcloud.db_password }}';"
        sudo -u postgres psql -c "ALTER USER {{ nextcloud.db_user }} WITH PASSWORD '{{ nextcloud.db_password }}';"
    - require:
      - service: nextcloud_postgresql_service

nextcloud_db:
  cmd.run:
    - name: |
        sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='{{ nextcloud.db_name }}'" | grep -q 1 || \
        sudo -u postgres createdb -O {{ nextcloud.db_user }} {{ nextcloud.db_name }}
    - require:
      - cmd: nextcloud_db_user

nextcloud_db_grant:
  cmd.run:
    - name: sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE {{ nextcloud.db_name }} TO {{ nextcloud.db_user }};"
    - require:
      - cmd: nextcloud_db