{%- from 'tool-yabai/map.jinja' import yabai -%}

Yabai is restarted:
  cmd.wait:
    - name: launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
    - runas: {{ yabai._brew_user }}

{%- for user in yabai.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}

yabai configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._yabai.confdir }}
    - source:
      - salt://dotconfig/{{ user.name }}/yabai
      - salt://dotconfig/yabai
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
    - watch_in:
      - Yabai is restarted
{%- endfor %}
