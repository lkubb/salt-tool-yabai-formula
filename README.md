# Yabai Formula
Sets up, configures and updates Yabai window manager for MacOS.

## Usage
Applying `tool-yabai` will make sure `yabai` is configured as specified.

## Notes
### SIP
[Some of the functionality](https://github.com/koekeishiya/yabai/issues/13) of Yabai needs System Integrity Protection (SIP) disabled. The process [is decribed](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection) in the excellent wiki. Basic functionality works without disabling it. This formula will work either way.

### M1
To be able to load the scripting addon after having disabled SIP, it is mandatory to allow non-Apple-signed arm64e binaries with `sudo nvram boot-args=-arm64e_preview_abi`. This is automated in this state. You will need to reboot for that setting to apply.

### Monterey
The current stable release is for Big Sur, to run Yabai on Monterey, Homebrew needs to compile the latest development edition from HEAD.

## Configuration
### Pillar

#### User-specific
The following shows an example of `tool-yabai` pillar configuration. Namespace it to `tool:users` and/or `tool:yabai:users`.
```yaml
user:
  # sync this user's config from a dotfiles repo available as 
  # salt://dotconfig/<user>/yabai or salt://dotconfig/yabai
  dotconfig:              # can be bool or mapping
    file_mode: '0600'     # default: keep destination or salt umask (new)
    dir_mode: '0700'      # default: 0700
    clean: false          # delete files in target. default: false
  yabai:
    # On MacOS >=11 (Big Sur), the scripting addon needs to be
    # loaded with root privileges. This sets up passwordless sudo
    # for this user to be able to autoload it in yabairc with
    # sudo yabai --load-sa
    pwless_sudo: false
```

#### Formula-specific
There are none currently.

#### Note on general `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

### Dotfiles
`tool-yabai.configsync` will recursively apply templates from

- `salt://dotconfig/<user>/yabai` or
- `salt://dotconfig/yabai`

to the user's config dir for every user that has it enabled (see `user.dotconfig`). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).
