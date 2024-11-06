# vim: ft=sls

{#-
    Stops the Yabai service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}


Yabai service is dead:
  cmd.run:
    - name: brew services stop {{ yabai.lookup.service.name }}
    - runas: {{ yabai.lookup.brew_user }}
    - onlyif:
      - sudo -u {{ yabai.lookup.brew_user }} brew services list | grep -e '^{{ yabai.lookup.service.name }}' | grep started
