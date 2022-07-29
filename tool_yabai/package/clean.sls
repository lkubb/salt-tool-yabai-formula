# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - {{ sls_config_clean }}


Yabai is removed:
  pkg.removed:
    - name: {{ yabai.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
