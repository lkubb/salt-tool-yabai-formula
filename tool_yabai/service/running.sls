# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - {{ sls_package_install }}


Yabai service is running:
  cmd.run:
    - name: brew services start {{ yabai.lookup.service.name }}
    - runas: {{ yabai.lookup.brew_user }}
    - unless:
      - sudo -u {{ yabai.lookup.brew_user }} brew services list | grep -e '^{{ yabai.lookup.service.name }}' | grep started
    - require:
      - Yabai is installed
