# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


{%- if yabai.users |
        selectattr("yabai.sketchybar", "defined") |
        selectattr("yabai.sketchybar.lua_mod", "defined") |
        selectattr("yabai.sketchybar.lua_mod") | list %}

Sketchybar Lua API module is removed:
  file.absent:
    - names:
{%-   for user in yabai.users |
        selectattr("yabai.sketchybar", "defined") |
        selectattr("yabai.sketchybar.lua_mod", "defined") |
        selectattr("yabai.sketchybar.lua_mod") %}
      - {{ user.home | path_join(yabai.lookup.sketchybar.sbarlua.src) }}
      - {{ user.home | path_join(yabai.lookup.sketchybar.sbarlua.target) }}
{%-   endfor %}
{%- endif %}
