# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


{%- if yabai.users |
        selectattr("yabai.sketchybar", "defined") |
        selectattr("yabai.sketchybar.lua_mod", "defined") |
        selectattr("yabai.sketchybar.lua_mod") |
        list %}

Lua is installed for sbarlua:
  pkg.installed:
    - name: lua
    - require_in:
{%-   for user in yabai.users |
      selectattr("yabai.sketchybar", "defined") |
      selectattr("yabai.sketchybar.lua_mod", "defined") |
      selectattr("yabai.sketchybar.lua_mod") %}
      - Sketchybar Lua API module is installed for user {{ user.name }}
{%-   endfor %}
{%- endif %}

{%- for user in yabai.users |
      selectattr("yabai.sketchybar", "defined") |
      selectattr("yabai.sketchybar.lua_mod", "defined") |
      selectattr("yabai.sketchybar.lua_mod") %}

Sketchybar Lua API module is installed for user {{ user.name }}:
  git.latest:
    - name: {{ yabai.lookup.sketchybar.sbarlua.repo }}
    - target: {{ user.home | path_join(yabai.lookup.sketchybar.sbarlua.src) }}
    - user: {{ user.name }}
  cmd.run:
    - name: make install
    - cwd: {{ user.home | path_join(yabai.lookup.sketchybar.sbarlua.src) }}
    - runas: {{ user.name }}
    - onchanges:
      - git: {{ yabai.lookup.sketchybar.sbarlua.repo }}
{%- endfor %}
