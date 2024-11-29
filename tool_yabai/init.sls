# vim: ft=sls

{#-
    *Meta-state*.

    Performs all operations described in this formula according to the specified configuration.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - .package
  - .scripting_addon
  - .config
{%- if yabai.sketchybar.install %}
  - .sketchybar
{%- endif %}
  - .service
