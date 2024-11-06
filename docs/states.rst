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


``tool_yabai.service.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Stops the Yabai service and disables it at boot time.


