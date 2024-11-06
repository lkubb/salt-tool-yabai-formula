# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_yabai`` meta-state
    in reverse order.
#}

include:
  - .service.clean
  - .config.clean
  - .scripting_addon.clean
  - .package.clean
