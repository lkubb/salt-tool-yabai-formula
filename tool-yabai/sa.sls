{%- from 'tool-yabai/map.jinja' import yabai -%}

{%- if not yabai._sip %}
  {%- if yabai._m1 %}

Allowing non-Apple-signed arm64e binaries:
  cmd.run:
    - name: nvram boot-args=-arm64e_preview_abi
    - unless:
      # for whatever reason, the dash still needs to be escaped
      - nvram boot-args | grep '\-arm64e_preview_abi'
  {%- endif %}

  {%- if yabai.users | selectattr('yabai.pwless_sudo', 'defined') |
      selectattr('yabai.pwless_sudo') | list %}

Passwordless sudo is setup:
  file.managed:
    - name: /private/etc/sudoers.d/yabai
    - contents: |
        {{ ', '.join(yabai.users |
          selectattr('yabai.pwless_sudo', 'defined') |
          selectattr('yabai.pwless_sudo') |
          map(attribute='name'))
        }} ALL = (root) NOPASSWD: {{ yabai._brew_prefix }}/bin/yabai --load-sa
    - user: root
    - group: wheel
  {%- endif %}
{%- endif %}
