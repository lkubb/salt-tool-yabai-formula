# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - {{ sls_service_clean }}


{%- for user in yabai.users %}

Yabai config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_yabai'].confdir }}
{%- endfor %}
