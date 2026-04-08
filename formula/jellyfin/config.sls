{% from "jellyfin/map.jinja" import jellyfin with context %}

jellyfin_media_dir:
  file.directory:
    - name: {{ jellyfin.media_folder }}
    - user: jellyfin
    - group: jellyfin
    - mode: '0755'
    - makedirs: true
    - require:
      - pkg: jellyfin_pkg

jellyfin_data_dir:
  file.directory:
    - name: {{ jellyfin.data_folder }}
    - user: jellyfin
    - group: jellyfin
    - mode: '0750'
    - require:
      - pkg: jellyfin_pkg

jellyfin_cache_dir:
  file.directory:
    - name: {{ jellyfin.cache_folder }}
    - user: jellyfin
    - group: jellyfin
    - mode: '0750'
    - require:
      - pkg: jellyfin_pkg

jellyfin_log_dir:
  file.directory:
    - name: {{ jellyfin.log_folder }}
    - user: jellyfin
    - group: jellyfin
    - mode: '0750'
    - require:
      - pkg: jellyfin_pkg