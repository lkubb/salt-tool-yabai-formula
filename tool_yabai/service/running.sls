# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}

include:
  - {{ sls_package_install }}


{%- for user in yabai.users | selectattr("yabai.autostart", "false") %}

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

{%- for user in yabai.users | rejectattr("yabai.autostart", "false") %}

Yabai service is loaded during login for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join("Library", "LaunchAgents", yabai.lookup.service.name ~ ".plist") }}
    - source: {{ files_switch(
                    ["com.koekeishiya.yabai.plist", "com.koekeishiya.yabai.plist.j2"],
                    lookup="Yabai service is loaded during login for user '{}'".format(user.name),
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
      - Yabai is installed
{%-   if user.dotconfig %}
      - Yabai configuration is synced for user '{{ user.name }}'
{%-   endif %}
    - context:
        yabai: {{ yabai | json }}
        user: {{ user | json }}

{%-   if user.name == yabai.lookup.console_user %}

Yabai service is running:
  service.running:
    - name: {{ yabai.lookup.service.name }}
    - enable: true
    - require:
      - Yabai service is loaded during login for user '{{ user.name }}'
{%-     if user.dotconfig %}
    - watch:
      - Yabai configuration is synced for user '{{ user.name }}'
{%-     endif %}
{%-   endif %}
{%- endfor %}
