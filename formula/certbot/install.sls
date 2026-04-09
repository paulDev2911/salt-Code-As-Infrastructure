certbot_pkg:
  pkg.installed:
    - pkgs:
      - certbot
      - python3-certbot-dns-porkbun

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
      - pkg: certbot_pkg