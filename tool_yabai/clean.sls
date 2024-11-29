# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_yabai`` meta-state
    in reverse order.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - .service.clean
{%- if yabai.sketchybar.install %}
  - .sketchybar.clean
{%- endif %}
  - .config.clean
  - .scripting_addon.clean
  - .package.clean
