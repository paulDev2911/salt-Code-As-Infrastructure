{% set users = salt['pillar.get']('users', {}) %}

{% for username, user in users.items() %}
{% if user.get('absent', false) %}

users_{{ username }}_absent:
  user.absent:
    - name: {{ username }}
    - purge: true
    - force: true

users_{{ username }}_sudoers_absent:
  file.absent:
    - name: /etc/sudoers.d/{{ username }}

{% endif %}
{% endfor %}