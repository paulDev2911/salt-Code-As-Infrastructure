{% from "users/map.jinja" import defaults with context %}
{% set users = salt['pillar.get']('users', {}) %}

include:
  - users.sudo

{% for username, user in users.items() %}
{% if not user.get('absent', false) %}

users_{{ username }}_group:
  group.present:
    - name: {{ username }}

users_{{ username }}_user:
  user.present:
    - name: {{ username }}
    - gid: {{ username }}
    - home: /home/{{ username }}
    - shell: {{ user.get('shell', defaults.shell) }}
    - groups: {{ user.get('groups', []) }}
    - require:
      - group: users_{{ username }}_group

{% if user.get('ssh_keys') %}
users_{{ username }}_ssh_keys:
  ssh_auth.present:
    - user: {{ username }}
    - names: {{ user['ssh_keys'] }}
    - require:
      - user: users_{{ username }}_user
{% endif %}

{% endif %}
{% endfor %}