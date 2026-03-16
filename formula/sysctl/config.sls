{% from "sysctl/map.jinja" import sysctl with context %}

{% for param, settings in sysctl.get('params', {}).items() %}

{% if settings is mapping %}
  {% set value = settings.value %}
  {% set config = settings.get('config', '99-salt.conf') %}
{% else %}
  {% set value = settings %}
  {% set config = '99-salt.conf' %}
{% endif %}

sysctl_{{ param | replace('.', '_') }}:
  sysctl.present:
    - name: {{ param }}
    - value: {{ value }}
    - config: /etc/sysctl.d/{{ config }}
    - require:
      - pkg: sysctl_pkg

{% endfor %}
