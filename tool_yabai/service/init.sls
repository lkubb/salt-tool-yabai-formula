# vim: ft=sls

{#-
    Starts the Yabai service and enables it at boot time.
    Has a dependency on `tool_yabai.config`_.
#}

include:
  - .running
