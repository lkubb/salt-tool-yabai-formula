# vim: ft=sls

{#-
    Removes Sketchybar App Font.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


{%- for user in yabai.users |
      selectattr("yabai.sketchybar", "defined") |
      selectattr("yabai.sketchybar.app_font", "defined") |
      selectattr("yabai.sketchybar.app_font") %}

Sketchybar App Font is removed for user {{ user.name }}:
  file.absent:
    - name: {{ user.home | path_join(yabai.lookup.sketchybar.app_font.target) }}
{%- endfor %}
