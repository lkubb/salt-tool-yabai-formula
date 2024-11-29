# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_yabai.sketchybar`` meta-state
    in reverse order.
#}

include:
  - .service.clean
  - .config.clean
  - .sbarlua.clean
  - .app_font.clean
  - .package.clean
