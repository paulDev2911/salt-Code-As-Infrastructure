{% from "nextcloud/map.jinja" import nextcloud with context %}

nextcloud_postgresql:
  pkg.installed:
    - name: postgresql

nextcloud_postgresql_service:
  service.running:
    - name: postgresql
    - enable: true
    - require:
      - pkg: nextcloud_postgresql

nextcloud_db_user:
  postgres_user.present:
    - name: {{ nextcloud.db_user }}
    - password: {{ nextcloud.db_password }}
    - encrypted: false
    - require:
      - service: nextcloud_postgresql_service

nextcloud_db_user_password:
  cmd.run:
    - name: sudo -u postgres psql -c "ALTER USER {{ nextcloud.db_user }} WITH PASSWORD '{{ nextcloud.db_password }}';"
    - require:
      - postgres_user: nextcloud_db_user

nextcloud_db:
  postgres_database.present:
    - name: {{ nextcloud.db_name }}
    - owner: {{ nextcloud.db_user }}
    - require:
      - postgres_user: nextcloud_db_user

nextcloud_db_grant:
  postgres_privileges.present:
    - name: {{ nextcloud.db_user }}
    - object_name: {{ nextcloud.db_name }}
    - object_type: database
    - privileges:
      - ALL
    - require:
      - postgres_database: nextcloud_db
      - postgres_user: nextcloud_db_user