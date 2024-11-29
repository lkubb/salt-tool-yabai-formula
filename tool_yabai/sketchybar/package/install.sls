# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


Sketchybar is installed:
  pkg.installed:
    - name: {{ yabai.lookup.sketchybar.pkg.name }}
