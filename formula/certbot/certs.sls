{% from "certbot/map.jinja" import certbot with context %}

{% for domain in certbot.domains %}

certbot_cert_{{ domain | replace('.', '_') }}:
  cmd.run:
    - name: |
        certbot certonly \
          --dns-porkbun \
          --dns-porkbun-credentials /etc/letsencrypt/porkbun.ini \
          --non-interactive \
          --agree-tos \
          --email {{ certbot.email }} \
          -d {{ domain }}
    - creates: /etc/letsencrypt/live/{{ domain }}/fullchain.pem
    - require:
      - file: certbot_porkbun_credentials

{% endfor %}