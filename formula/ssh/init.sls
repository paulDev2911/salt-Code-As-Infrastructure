{% from "ssh/map.jinja" import defaults with context %}
{% set ssh = salt['pillar.get']('ssh', {}) %}

ssh_pkg:
  pkg.installed:
    - name: openssh-server

ssh_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - mode: '0600'
    - user: root
    - group: root
    - contents: |
        Port {{ ssh.get('port', defaults.port) }}
        
        PermitRootLogin {{ ssh.get('permit_root_login', defaults.permit_root_login) }}
        PasswordAuthentication {{ ssh.get('password_authentication', defaults.password_authentication) }}
        PubkeyAuthentication {{ ssh.get('pubkey_authentication', defaults.pubkey_authentication) }}
        
        X11Forwarding {{ ssh.get('x11_forwarding', defaults.x11_forwarding) }}
        MaxAuthTries {{ ssh.get('max_auth_tries', defaults.max_auth_tries) }}
        LoginGraceTime {{ ssh.get('login_grace_time', defaults.login_grace_time) }}
        
        PubkeyAcceptedAlgorithms {{ ssh.get('allowed_algorithms', defaults.allowed_algorithms) }}
        
        AuthorizedKeysFile .ssh/authorized_keys
        
        # Disable unused auth methods
        KerberosAuthentication no
        GSSAPIAuthentication no
        UsePAM yes
        
        # Logging
        SyslogFacility AUTH
        LogLevel VERBOSE
    - require:
      - pkg: ssh_pkg

ssh_service:
  service.running:
    - name: ssh
    - enable: true
    - watch:
      - file: ssh_config