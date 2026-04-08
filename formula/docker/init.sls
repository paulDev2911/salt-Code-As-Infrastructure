docker_deps:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
      - gnupg

docker_repo_gpg:
  cmd.run:
    - name: |
        curl -fsSL https://download.docker.com/linux/debian/gpg \
          | gpg --dearmor -o /usr/share/keyrings/docker.gpg
    - creates: /usr/share/keyrings/docker.gpg
    - require:
      - pkg: docker_deps

docker_repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable
    - file: /etc/apt/sources.list.d/docker.list
    - require:
      - cmd: docker_repo_gpg

docker_pkg:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - require:
      - pkgrepo: docker_repo

docker_service:
  service.running:
    - name: docker
    - enable: true
    - require:
      - pkg: docker_pkg