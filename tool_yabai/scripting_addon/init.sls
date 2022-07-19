# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}

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

# This makes sure that the scripting addon can be loaded without
# `sudo`. To prevent a local privilege escalation – the yabai binary
# is possibly owned by the user logged in as an admin and can easily
# be replaced – the sha256 digest of the yabai binary is embedded
# into the sudoers file. To avoid embedding a possibly replaced
# binary's hash, this state only runs on changes in the package
# state. If brew uhas pgraded the binary otherwise, you will need
# to ensure that the hash is correct manually.
# see https://github.com/koekeishiya/yabai/issues/1318
Passwordless sudo is setup:
  file.managed:
    - name: /private/etc/sudoers.d/yabai
    - source: {{ files_switch(['sudoers', 'sudoers.j2'],
                              lookup='Passwordless sudo is setup'
                 )
              }}
    - user: root
    - group: wheel
    - template: jinja
    - onchanges:
      - Yabai is installed
    - context:
        yabai: {{ yabai | json }}
{%-   endif %}
{%- endif %}
