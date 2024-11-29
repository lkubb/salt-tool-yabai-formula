# vim: ft=sls

{#-
    Installs Sketchybar Lua API module.

    In your Sketchybar config, you need to add the module dir to the lua cpath:

      package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

    Then you can require it:

      local sbar = require("sketchybar")

    For details, see the repo README at https://github.com/FelixKratz/SbarLua
#}

include:
  - .install
