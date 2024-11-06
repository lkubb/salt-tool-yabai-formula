# vim: ft=sls

{#-
    Syncs the Yabai service configuration
    with a dotfiles repo.
    Has a dependency on `tool_yabai.package`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}


Yabai is restarted:
  cmd.wait:  # noqa: 213
    - name: launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
    - runas: {{ yabai.lookup.brew_user }}

{%- for user in yabai.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}

Yabai configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user["_yabai"].confdir }}
    - source: {{ files_switch(
                ["yabai"],
                default_files_switch=["id", "os_family"],
                override_root="dotconfig",
                opt_prefixes=[user.name]) }}
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
    - watch_in:
      - Yabai is restarted
{%- endfor %}
