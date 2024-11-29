# vim: ft=sls

{#-
    Removes the configuration of the Sketchybar service and has a
    dependency on `tool_yabai.sketchybar.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".sketchybar.service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - {{ sls_service_clean }}


{%- for user in yabai.users %}
{%-   set confdir = user.home | path_join(yabai.lookup.sketchybar.config.dir) %}

Sketchybar config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ confdir }}
{%- endfor %}
