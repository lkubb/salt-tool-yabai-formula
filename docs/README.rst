.. _readme:

Yabai Formula
=============

Manages Yabai tiling window manager in the user environment.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_yabai`` will make sure ``yabai`` is configured as specified.

Notes
-----
SIP
~~~
`Some of the functionality <https://github.com/koekeishiya/yabai/issues/13>`_ of Yabai needs System Integrity Protection (SIP) disabled. The process `is decribed <https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection>`_ in the excellent wiki. Basic functionality works without disabling it. This formula will work either way.

M1 Macs
~~~~~~~
To be able to load the scripting addon after having disabled SIP, it is mandatory to allow non-Apple-signed arm64e binaries with ``sudo nvram boot-args=-arm64e_preview_abi``. This is automated in this state. You will need to reboot for that setting to apply.

macOS Monterey
~~~~~~~~~~~~~~
The current stable release is for Big Sur, to run Yabai on Monterey, Homebrew needs to compile the latest development edition from HEAD.

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_yabai`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_yabai:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_yabai/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Force the usage of XDG directories for this user.
    xdg: true

      # Sync this user's config from a dotfiles repo.
      # The available paths and their priority can be found in the
      # rendered `config/sync.sls` file (currently, @TODO docs).
      # Overview in descending priority:
      # salt://dotconfig/<minion_id>/<user>/yabai
      # salt://dotconfig/<minion_id>/yabai
      # salt://dotconfig/<os_family>/<user>/yabai
      # salt://dotconfig/<os_family>/yabai
      # salt://dotconfig/default/<user>/yabai
      # salt://dotconfig/default/yabai
    dotconfig:              # can be bool or mapping
      file_mode: '0600'     # default: keep destination or salt umask (new)
      dir_mode: '0700'      # default: 0700
      clean: false          # delete files in target. default: false

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_yabai:users`.
      # Set this to `false` to disable configuration for this user.
    yabai:
        # On MacOS >=11 (Big Sur), the scripting addon needs to be
        # loaded with root privileges. This sets up passwordless sudo
        # for this user to be able to autoload it in yabairc with
        # `sudo yabai --load-sa`.
      pwless_sudo: true

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_yabai:

      # Specify an explicit version (works on most Linux distributions) or
      # keep the packages updated to their latest version on subsequent runs
      # by leaving version empty or setting it to 'latest'
      # (again for Linux, brew does that anyways).
    version: latest

      # Install from HEAD instead of tagged release.
      # This is needed for MacOS Monterey currently.
    dev_version: false

      # Default formula configuration for all users.
    defaults:
      pwless_sudo: default value for all users

Dotfiles
~~~~~~~~
``tool_yabai.config.sync`` will recursively apply templates from

* ``salt://dotconfig/<minion_id>/<user>/yabai``
* ``salt://dotconfig/<minion_id>/yabai``
* ``salt://dotconfig/<os_family>/<user>/yabai``
* ``salt://dotconfig/<os_family>/yabai``
* ``salt://dotconfig/default/<user>/yabai``
* ``salt://dotconfig/default/yabai``

to the user's config dir for every user that has it enabled (see ``user.dotconfig``). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

The URL list above is in descending priority. This means user-specific configuration from wider scopes will be overridden by more system-specific general configuration.

Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Reference
---------
* https://github.com/koekeishiya/yabai/wiki/ (excellent wiki)
