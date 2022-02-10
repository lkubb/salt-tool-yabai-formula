{%- from 'tool-yabai/map.jinja' import yabai -%}

include:
  - .package
  - .service
  - .sa
{%- if yabai.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  - .configsync
{%- endif %}
