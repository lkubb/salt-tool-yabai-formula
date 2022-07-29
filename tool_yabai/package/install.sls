# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


Yabai is installed:
  pkg.installed:
    - name: {{ yabai.lookup.pkg.name }}
{%- if yabai.get("dev_version") %}
    - options: '--HEAD'
{%- endif %}

Yabai setup is completed:
  test.nop:
    - name: Hooray, Yabai setup has finished.
    - require:
      - pkg: {{ yabai.lookup.pkg.name }}
