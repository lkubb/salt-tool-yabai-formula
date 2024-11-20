# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


{%- if not yabai._sip %}
{%-   if yabai.lookup.m1 %}

Not allowing non-Apple-signed arm64e binaries:
  cmd.run:
    - name: nvram -d boot-args
    - onlyif:
      # for whatever reason, the dash still needs to be escaped
      - nvram boot-args | grep '\-arm64e_preview_abi'
{%-   endif %}

{%-   if yabai.users | selectattr("yabai.pwless_sudo", "true") | list %}

Passwordless sudo is not setup:
  file.absent:
    - name: /private/etc/sudoers.d/yabai
{%-   endif %}
{%- endif %}
