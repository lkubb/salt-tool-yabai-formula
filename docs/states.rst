Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_yabai``
~~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_yabai.package``
~~~~~~~~~~~~~~~~~~~~~~
Installs the Yabai package only.


``tool_yabai.scripting_addon``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_yabai.config``
~~~~~~~~~~~~~~~~~~~~~
Manages the Yabai service configuration by

* recursively syncing from a dotfiles repo

Has a dependency on `tool_yabai.package`_.


``tool_yabai.sketchybar``
~~~~~~~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Manage sketchybar.


``tool_yabai.sketchybar.app_font``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Installs Sketchybar App Font (contains app icons).

https://github.com/kvndrsslr/sketchybar-app-font


``tool_yabai.sketchybar.config``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Manages the Yabai service configuration by

* recursively syncing from a dotfiles repo

Has a dependency on `tool_yabai.package`_.


``tool_yabai.sketchybar.package``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Installs Sketchybar.


``tool_yabai.sketchybar.sbarlua``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Installs Sketchybar Lua API module.

In your Sketchybar config, you need to add the module dir to the lua cpath:

  package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

Then you can require it:

  local sbar = require("sketchybar")

For details, see the repo README at https://github.com/FelixKratz/SbarLua


``tool_yabai.sketchybar.service``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Starts the Sketchybar service and enables it at boot time.
Has a dependency on `tool_yabai.config`_.


``tool_yabai.service``
~~~~~~~~~~~~~~~~~~~~~~
Starts the Yabai service and enables it at boot time.
Has a dependency on `tool_yabai.config`_.


``tool_yabai.clean``
~~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_yabai`` meta-state
in reverse order.


``tool_yabai.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the Yabai package.
Has a dependency on `tool_yabai.config.clean`_.


``tool_yabai.scripting_addon.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_yabai.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the Yabai service and has a
dependency on `tool_yabai.service.clean`_.


``tool_yabai.sketchybar.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_yabai.sketchybar`` meta-state
in reverse order.


``tool_yabai.sketchybar.app_font.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes Sketchybar App Font.


``tool_yabai.sketchybar.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the Sketchybar service and has a
dependency on `tool_yabai.sketchybar.service.clean`_.


``tool_yabai.sketchybar.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes Sketchybar.
Has a dependency on `tool_yabai.sketchybar.config.clean`_.


``tool_yabai.sketchybar.sbarlua.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_yabai.sketchybar.service.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Stops the Sketchybar service and disables it at boot time.


``tool_yabai.service.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Stops the Yabai service and disables it at boot time.


