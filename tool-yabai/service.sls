{%- from 'tool-yabai/map.jinja' import yabai -%}

include:
  - .package

Yabai service is running:
  cmd.run:
    - name: brew services start yabai
    - runas: {{ yabai._brew_user }}
    - unless:
      - sudo -u {{ yabai._brew_user }} brew services list | grep -e '^yabai' | grep started
    - require:
      - Yabai is installed
