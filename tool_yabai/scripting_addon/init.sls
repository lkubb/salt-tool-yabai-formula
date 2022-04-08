# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

include:
  - {{ sls_package_install }}

{%- if not yabai.lookup.sip %}
{%-   if yabai.lookup.m1 %}

Allowing non-Apple-signed arm64e binaries:
  cmd.run:
    - name: nvram boot-args=-arm64e_preview_abi
    - unless:
      # for whatever reason, the dash still needs to be escaped
      - nvram boot-args | grep '\-arm64e_preview_abi'
    - require:
      - sls: {{ sls_package_install }}
{%-   endif %}

{%-   if yabai.users | selectattr('yabai.pwless_sudo', 'defined') |
      selectattr('yabai.pwless_sudo') | list %}

Passwordless sudo is setup:
  file.managed:
    - name: /private/etc/sudoers.d/yabai
    - contents: |
        {{ ', '.join(yabai.users |
          selectattr('yabai.pwless_sudo', 'defined') |
          selectattr('yabai.pwless_sudo') |
          map(attribute='name'))
        }} ALL = (root) NOPASSWD: {{ yabai.lookup.brew_prefix }}/bin/yabai --load-sa
    - user: root
    - group: wheel
    - require:
      - sls: {{ sls_package_install }}
{%-   endif %}
{%- endif %}
