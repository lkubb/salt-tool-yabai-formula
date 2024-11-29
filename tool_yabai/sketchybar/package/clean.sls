# vim: ft=sls

{#-
    Removes Sketchybar.
    Has a dependency on `tool_yabai.sketchybar.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".sketchybar.config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - {{ sls_config_clean }}


Sketchybar is removed:
  pkg.removed:
    - name: {{ yabai.lookup.sketchybar.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
