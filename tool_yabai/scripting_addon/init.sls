# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as yabai with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}

include:
  - {{ sls_package_install }}

{%- if not yabai.lookup.sip %}
{%-   if yabai.lookup.m1 %}

Allowing non-Apple-signed arm64e binaries:
  cmd.run:
    - name: nvram boot-args=-arm64e_preview_abi
    - unless:
      # for whatever reason, the dash still needs to be escaped
      - nvram boot-args | grep '\-arm64e_preview_abi'
    - require:
      - sls: {{ sls_package_install }}
{%-   endif %}

{%-   if grains.osmajorrelease <= 15 %}

# At least on Sequoia and Yabai v7.1.16+, the SA fails to load if unpatched.
# https://github.com/asmvik/yabai/issues/2686#issuecomment-3678216885
Scripting addon PAC ABI version is patched:
  cmd.run:
    - name: |
        LOADER="/Library/ScriptingAdditions/yabai.osax/Contents/MacOS/loader"
        # Get index (I) and offset (O) for caps 0x81
        read I O <<< $(otool -f "$LOADER" | awk '/architecture/{i=$2} /capabilities 0x81/{f=1} f&&/offset/{print i, $2; exit}')

        if [ -n "$O" ]; then
            # Patch Fat (offset+4) and Mach-O (slice+11) -> 0x80
            printf '\x80' | dd of="$LOADER" bs=1 seek=$((8 + I*20 + 4)) count=1 conv=notrunc 2>/dev/null
            printf '\x80' | dd of="$LOADER" bs=1 seek=$((O + 11)) count=1 conv=notrunc 2>/dev/null

            echo "Patched $LOADER (Arch $I). Resigning..."
            codesign -f -s - "$LOADER" &>/dev/null
        else
            echo "No target architecture (caps 0x81) found in '$LOADER'."
        fi
    - onlyif:
      - |
          LOADER="/Library/ScriptingAdditions/yabai.osax/Contents/MacOS/loader"
          # Get index (I) and offset (O) for caps 0x81
          read I O <<< $(otool -f "$LOADER" | awk '/architecture/{i=$2} /capabilities 0x81/{f=1} f&&/offset/{print i, $2; exit}')
          [ -n "$O" ] || exit 1
{%-   endif %}

{%-   if yabai.users | selectattr("yabai.pwless_sudo", "true") | list %}

# This makes sure that the scripting addon can be loaded without
# `sudo`. To prevent a local privilege escalation – the yabai binary
# is possibly owned by the user logged in as an admin and can easily
# be replaced – the sha256 digest of the yabai binary is embedded
# into the sudoers file. To avoid embedding a possibly replaced
# binary's hash, this state only runs on changes in the package
# state. If brew has upgraded the binary otherwise, you will need
# to ensure that the hash is correct manually.
# see https://github.com/asmvik/yabai/issues/1318
Passwordless sudo is setup:
  file.managed:
    - name: /private/etc/sudoers.d/yabai
    - source: {{ files_switch(
                    ["sudoers", "sudoers.j2"],
                    lookup="Passwordless sudo is setup",
                    config=yabai,
                 )
              }}
    - user: root
    - group: wheel
    - template: jinja
    - onchanges:
      - Yabai is installed
    - context:
        yabai: {{ yabai | json }}
{%-   endif %}
{%- endif %}
