{% from "fail2ban/map.jinja" import fail2ban with context %}

fail2ban_config:
  file.managed:
    - name: /etc/fail2ban/fail2ban.local
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        [DEFAULT]
        loglevel = {{ fail2ban.loglevel }}
        logtarget = {{ fail2ban.logtarget }}
        bantime = {{ fail2ban.bantime }}
        findtime = {{ fail2ban.findtime }}
        maxretry = {{ fail2ban.maxretry }}
        backend = {{ fail2ban.backend }}
        usedns = {{ fail2ban.usedns }}
    - require:
      - pkg: fail2ban_pkg

fail2ban_jail_config:
  file.managed:
    - name: /etc/fail2ban/jail.local
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        [DEFAULT]
        bantime = {{ fail2ban.bantime }}
        findtime = {{ fail2ban.findtime }}
        maxretry = {{ fail2ban.maxretry }}

        {% for jail_name, jail in fail2ban.get('jails', {}).items() %}
        [{{ jail_name }}]
        enabled = {{ jail.get('enabled', true) | lower }}
        {% if jail.get('port') %}port = {{ jail.port }}{% endif %}
        {% if jail.get('filter') %}filter = {{ jail.filter }}{% endif %}
        {% if jail.get('logpath') %}logpath = {{ jail.logpath }}{% endif %}
        {% if jail.get('maxretry') %}maxretry = {{ jail.maxretry }}{% endif %}
        {% if jail.get('bantime') %}bantime = {{ jail.bantime }}{% endif %}
        {% if jail.get('action') %}action = {{ jail.action }}{% endif %}

        {% endfor %}
    - require:
      - pkg: fail2ban_pkg
