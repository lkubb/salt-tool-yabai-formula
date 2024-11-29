# vim: ft=sls

{#-
    Syncs the Sketchybar service configuration
    with a dotfiles repo.
    Has a dependency on `tool_yabai.sketchybar.package`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".sketchybar.package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}

include:
  - {{ sls_package_install }}


{%- for user in yabai.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}
{%-   set confdir = user.home | path_join(yabai.lookup.sketchybar.config.dir) %}

Sketchybar configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ confdir }}
    - source: {{ files_switch(
                    ["sketchybar"],
                    lookup="Sketchybar configuration is synced for user '{}'".format(user.name),
                    config=yabai,
                    path_prefix="dotconfig",
                    files_dir="",
                    custom_data={"users": [user.name]},
                 )
              }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
{%-   if dotconfig.get("file_mode") %}
    - file_mode: '{{ dotconfig.file_mode }}'
{%-   endif %}
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true
    - require:
      - sls: {{ sls_package_install }}
{%- endfor %}
