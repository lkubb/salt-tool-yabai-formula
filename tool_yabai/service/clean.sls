# vim: ft=sls

{#-
    Stops the Yabai service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}

{%- for user in yabai.users | rejectattr("yabai.autostart", "false") %}
{%-   if user.name == yabai.lookup.console_user %}

Yabai service is not running:
  service.dead:
    - name: {{ yabai.lookup.service.name }}
    - require_in:
      - Yabai service is ignored for user '{{ user.name }}'
{%-   endif %}

Yabai service is ignored for user '{{ user.name }}':
  file.absent:
    - name: {{ user.home | path_join("Library", "LaunchAgents", yabai.lookup.service.name ~ ".plist") }}

{%- endfor %}
