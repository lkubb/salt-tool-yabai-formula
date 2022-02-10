{%- from 'tool-yabai/map.jinja' import yabai -%}

Yabai is installed:
  pkg.installed:
    - name: koekeishiya/formulae/yabai
{%- if 12 <= grains['osmajorrelease'] | int %}
    - options: '--HEAD'
{%- endif %}

Yabai setup is completed:
  test.nop:
    - name: Hooray, Yabai setup has finished.
    - require:
      - pkg: koekeishiya/formulae/yabai
