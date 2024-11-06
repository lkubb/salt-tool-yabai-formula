# vim: ft=sls

{#-
    Manages the Yabai service configuration by

    * recursively syncing from a dotfiles repo

    Has a dependency on `tool_yabai.package`_.
#}

include:
  - .sync
