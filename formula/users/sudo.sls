{% from "users/map.jinja" import defaults with context %}
{% set users = salt['pillar.get']('users', {}) %}

users_sudo_pkg:
  pkg.installed:
    - name: sudo

users_sudoers_dir:
  file.directory:
    - name: /etc/sudoers.d
    - mode: '0750'
    - require:
      - pkg: users_sudo_pkg

{% for username, user in users.items() %}
{% if not user.get('absent', false) and user.get('sudo', defaults.sudo) %}

users_{{ username }}_sudoers:
  file.managed:
    - name: /etc/sudoers.d/{{ username }}
    - mode: '0440'
    - contents: |
        {{ username }} ALL=(ALL) {% if user.get('sudo_nopasswd', defaults.sudo_nopasswd) %}NOPASSWD:{% endif %}ALL
    - require:
      - file: users_sudoers_dir

{% endif %}
{% endfor %}