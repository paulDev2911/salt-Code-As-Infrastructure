{% from "certbot/map.jinja" import certbot with context %}

certbot_pkg:
  pkg.installed:
    - pkgs:
      - certbot
      - python3-pip

certbot_dns_porkbun:
  cmd.run:
    - name: pip3 install certbot-dns-porkbun --break-system-packages
    - unless: pip3 show certbot-dns-porkbun
    - require:
      - pkg: certbot_pkg

certbot_porkbun_credentials:
  file.managed:
    - name: /etc/letsencrypt/porkbun.ini
    - mode: '0600'
    - user: root
    - group: root
    - makedirs: true
    - contents: |
        dns_porkbun_key = {{ certbot.porkbun_api_key }}
        dns_porkbun_secret = {{ certbot.porkbun_secret_key }}
    - require:
      - cmd: certbot_dns_porkbun