# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_yabai.sketchybar`` meta-state
    in reverse order.
#}

include:
  - .service.clean
  - .sbarlua.clean
  - .config.clean
  - .package.clean
