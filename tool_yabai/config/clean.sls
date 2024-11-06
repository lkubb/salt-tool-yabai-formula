# vim: ft=sls

{#-
    Removes the configuration of the Yabai service and has a
    dependency on `tool_yabai.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - {{ sls_service_clean }}


{%- for user in yabai.users %}

Yabai config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_yabai"].confdir }}
{%- endfor %}
