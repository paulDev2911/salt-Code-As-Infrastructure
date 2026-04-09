{% from "certbot/map.jinja" import certbot with context %}

{% for domain in certbot.domains %}

certbot_cert_{{ domain | replace('.', '_') }}:
  cmd.run:
    - name: |
        certbot certonly \
          --authenticator dns-porkbun \
          --dns-porkbun-key {{ certbot.porkbun_api_key }} \
          --dns-porkbun-secret {{ certbot.porkbun_secret_key }} \
          --non-interactive \
          --agree-tos \
          --email {{ certbot.email }} \
          -d {{ domain }}
    - creates: /etc/letsencrypt/live/{{ domain }}/fullchain.pem
    - require:
      - cmd: certbot_dns_porkbun

{% endfor %}