# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_sync = tplroot ~ ".sketchybar.config.sync" %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}

include:
  - {{ sls_config_sync }}


{%- for user in yabai.users | selectattr("yabai.autostart", "false") %}

{%-   if user.name == yabai.lookup.console_user %}

Sketchybar service is not running:
  service.dead:
    - name: {{ yabai.lookup.sketchybar.service.name }}
    - require_in:
      - Sketchybar service is ignored for user '{{ user.name }}'
{%-   endif %}

Sketchybar service is ignored for user '{{ user.name }}':
  file.absent:
    - name: {{ user.home | path_join("Library", "LaunchAgents", yabai.lookup.sketchybar.service.name ~ ".plist") }}
{%- endfor %}

{%- for user in yabai.users | rejectattr("yabai.autostart", "false") %}

Sketchybar service is loaded during login for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join("Library", "LaunchAgents", yabai.lookup.sketchybar.service.name ~ ".plist") }}
    - source: {{ files_switch(
                    ["com.felixkratz.sketchybar.plist", "com.felixkratz.sketchybar.plist.j2"],
                    lookup="Sketchybar service is loaded during login for user '{}'".format(user.name),
                    config=yabai,
                    custom_data={"users": [user.name]},
                 )
              }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - template: jinja
    - mode: '0644'
    - makedirs: true
    - require:
      - Sketchybar is installed
{%-   if user.dotconfig %}
      - Sketchybar configuration is synced for user '{{ user.name }}'
{%-   endif %}
    - context:
        yabai: {{ yabai | json }}
        user: {{ user | json }}

{%-   if user.name == yabai.lookup.console_user %}

Sketchybar service is running:
  service.running:
    - name: {{ yabai.lookup.sketchybar.service.name }}
    - enable: true
    - watch:
      - Sketchybar service is loaded during login for user '{{ user.name }}'
{%-     if user.dotconfig %}
      - Sketchybar configuration is synced for user '{{ user.name }}'
{%-     endif %}
{%-   endif %}
{%- endfor %}
