{%- from 'tool-yabai/map.jinja' import yabai -%}

Yabai is restarted:
  cmd.wait:
    - name: launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
    - runas: {{ yabai._brew_user }}

{%- for user in yabai.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  {%- set dotconfig = user.dotconfig if dotconfig is mapping else {} %}

yabai configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._yabai.confdir }}
    - source:
      - salt://dotconfig/{{ user.name }}/yabai
      - salt://dotconfig/yabai
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
  {%- if dotconfig.get('file_mode') %}
    - file_mode: '{{ dotconfig.file_mode }}'
  {%- endif %}
    - dir_mode: '{{ dotconfig.get('dir_mode', '0700') }}'
    - clean: {{ dotconfig.get('clean', False) | to_bool }}
    - makedirs: True
    - watch_in:
      - Yabai is restarted
{%- endfor %}
