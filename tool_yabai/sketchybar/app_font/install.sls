# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


{%- for user in yabai.users |
      selectattr("yabai.sketchybar", "defined") |
      selectattr("yabai.sketchybar.app_font", "defined") |
      selectattr("yabai.sketchybar.app_font") %}

Sketchybar App Font is installed for user {{ user.name }}:
  file.managed:
    - name: {{ user.home | path_join(yabai.lookup.sketchybar.app_font.target) }}
    - source: {{ yabai.lookup.sketchybar.app_font.source }}
    - use_etag: true
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true
{%- endfor %}
