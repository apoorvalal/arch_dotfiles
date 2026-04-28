# Autorice

`autorice` is a prototype for task-aware ricing on Omarchy. It accepts a natural
language instruction or a named profile, classifies the task, and applies a
coordinated desktop state.

It currently controls:

- Omarchy theme via `omarchy-theme-set`
- Hyprland runtime overrides
- notification do-not-disturb mode through `makoctl`
- idle locking through `hypridle`
- power profile through `powerprofilesctl`
- Waybar status through the `custom/autorice` module

## Files

```text
autorice/
  README.md
  profiles/
    development/
      profile.conf
      hyprland.conf
    focus/
      profile.conf
      hyprland.conf
    gaming/
      profile.conf
      hyprland.conf
    media/
      profile.conf
      hyprland.conf
    presentation/
      profile.conf
      hyprland.conf
    reading/
      profile.conf
      hyprland.conf
personal_scripts/
  autorice
  autorice-widget
```

The executable is `~/dotfiles/personal_scripts/autorice`. The profile directory
is `~/dotfiles/autorice/profiles`.

## Commands

```bash
autorice apply "reading papers"
autorice apply development
autorice describe "dim ui with a browser on the left and terminal plus sublime stacked on the right"
autorice codex-plan "quiet browser and editor layout"
autorice detect
autorice status
autorice check
autorice list
autorice waybar
```

- `apply <text|profile>` classifies the text, loads the matching profile, and
  applies it. If the text looks like a freeform layout request, it uses the
  Codex planner path.
- `describe <text>` always asks the Codex planner for a constrained plan and
  applies it.
- `codex-plan <text>` prints the constrained Codex JSON plan without applying it.
- `detect` reads the active Hyprland window class/title and selected process
  hints, then applies the inferred profile.
- `status` prints the last applied profile, theme, request, and timestamp.
- `check` sequentially validates dependencies and every profile config.
- `list` prints available profile names.
- `waybar` prints JSON for Waybar's `custom/autorice` module.

## Dependency Behavior

The script separates core shell dependencies from desktop integrations.

Core dependencies are expected on a normal Linux install:

- `bash`
- `find`
- `sed`
- `paste`
- `date`
- `cp`
- `grep`
- `awk`

Desktop integrations are optional. If they are missing, `autorice apply` warns
and skips only the related step:

- `omarchy-theme-set`: applies `THEME`
- `hyprctl`: reloads Hyprland after writing the runtime override
- `hypridle`: applies `IDLE`
- `uwsm-app`: starts `hypridle` under UWSM when available
- `makoctl`: applies `DND`
- `powerprofilesctl`: applies `POWER_PROFILE`
- `notify-send`: emits profile notifications
- `waybar`: receives status refresh signals
- `pgrep`: detects active helper processes such as games
- `pkill`: stops helper processes and sends Waybar refresh signals
- `jq`: validates and reads Codex plans
- `codex`: produces plans for freeform layout descriptions
- `gjs`: renders desktop widgets
- `gtk4-layer-shell`: gives widgets a real desktop layer below normal app
  windows
- `playerctl`: feeds the media widget

Run this after changing any profile:

```bash
autorice check
```

The check walks the profiles in sorted order and verifies:

- the `profile.conf` file parses as Bash
- `THEME` exists in user or Omarchy theme directories
- `POWER_PROFILE` exists when `powerprofilesctl` is available
- `IDLE` is one of `on`, `off`, or `keep`
- `DND` is one of `on`, `off`, or `keep`
- `DESCRIPTION` is present
- every declared widget is supported
- the optional Hyprland override file exists

## Widgets

`autorice-widget` manages small profile-specific GTK widgets:

```bash
autorice-widget restart sysmon
autorice-widget restart media
autorice-widget stop
```

Profiles declare widgets with `WIDGETS=...` in `profile.conf`.

- `development` declares `WIDGETS=sysmon`, so `autorice dev` shows a desktop
  monitor with load, memory, disk, and thermal information.
- `media` declares `WIDGETS=media`, so `autorice media` shows a now-playing
  widget based on `playerctl`.

Switching to a profile with no `WIDGETS` stops existing autorice widgets. The
widget windows are GTK layer-shell windows on the bottom layer, so they stay out
of the tiling layout and sit below normal application windows instead of
covering them.

GJS needs `gtk4-layer-shell` to be preloaded before `libwayland-client`.
`autorice-widget` does that for its own process with
`/usr/lib/libgtk4-layer-shell.so`. Override that path with
`GTK4_LAYER_SHELL_LIB=/path/to/libgtk4-layer-shell.so` if the library lives
somewhere else.

## Codex Planner

`autorice describe` wraps `codex exec` for requests that are too specific for
the keyword classifier, for example:

```bash
autorice describe "dim ui with a web browser in one half and a terminal and sublime text stacked on the other"
```

The wrapper runs Codex with:

```bash
codex --sandbox read-only -a never --cd ~/dotfiles exec --output-schema autorice/codex-plan.schema.json
```

Codex is only allowed to produce JSON matching `autorice/codex-plan.schema.json`.
It does not get to execute commands or edit files. The local script then:

1. validates the JSON with `jq`
2. applies the selected Omarchy theme if available
3. writes a generated Hyprland override to
   `~/.local/state/omarchy/toggles/hypr/autorice.conf`
4. applies power, idle, and DND settings through the guarded helpers
5. launches allowlisted apps from the plan

The app allowlist is intentionally small:

- `browser`
- `terminal`
- `sublime`
- `editor`

The initial layout support is best-effort. For the browser-left/stack-right
shape, `autorice` switches to the requested workspace, nudges Hyprland's dwindle
split settings, and launches the apps in plan order. Hyprland still owns the
actual tiling behavior, so existing windows on the workspace can affect the
final arrangement.

`Ctrl+Super+Space` opens a generic terminal with
`AUTORICE_EPHEMERAL_TERMINAL=1`. When `autorice describe "..."` is run from
that terminal, `autorice` records the source window address and closes only that
terminal after applying the plan. Running `autorice` from an ordinary terminal
does not close the terminal.

Freeform layouts default to the active Hyprland workspace at invocation time.
The Codex planner sees that current workspace in its prompt, and the local
wrapper enforces it before applying the plan. To target another workspace, say
so explicitly, for example `workspace 4` or `desktop 4`. When the command is run
from the ephemeral terminal, that source terminal is moved to a hidden special
workspace before launching the planned apps so it does not affect the tiling
layout.

## Runtime State

`autorice` keeps generated state out of git:

- `~/.local/state/autorice/current`: last applied profile metadata
- `~/.local/state/omarchy/toggles/hypr/autorice.conf`: generated Hyprland
  override copied from the selected profile

`~/dotfiles/hypr/hyprland.conf` already sources
`~/.local/state/omarchy/toggles/hypr/*.conf`, so profile layout changes can be
applied without editing the base Hyprland config.

## How Classification Works

The classifier in `personal_scripts/autorice` is intentionally simple and local.
It lowercases the request and matches keywords:

- gaming keywords: `game`, `steam`, `lutris`, `heroic`, `proton`, `gamescope`,
  `fps`, `gpu`
- reading keywords: `read`, `paper`, `pdf`, `book`, `article`, `zathura`,
  `typora`, `notes`
- presentation keywords: `present`, `presentation`, `talk`, `demo`, `meeting`,
  `zoom`, `share`, `stream`
- media keywords: `media`, `music`, `playing`, `player`, `spotify`, `video`,
  `youtube`
- focus keywords: `focus`, `deep`, `write`, `quiet`, `dnd`, `concentrat`
- development keywords: `dev`, `code`, `terminal`, `editor`, `vim`, `nvim`,
  `sublime`, `vscode`, `python`, `rust`, `git`

If no keyword matches, it defaults to `development`.

## Profile Config Format

Every profile has a `profile.conf` file:

```bash
THEME=flexoki-dark
POWER_PROFILE=balanced
IDLE=on
DND=off
WIDGETS=sysmon
DESCRIPTION="dense development layout with normal notifications"
```

- `THEME`: Omarchy theme name passed to `omarchy-theme-set`.
- `POWER_PROFILE`: value passed to `powerprofilesctl set`, if available.
- `IDLE`: `on`, `off`, or `keep`; controls `hypridle`.
- `DND`: `on`, `off`, or `keep`; controls Mako's `do-not-disturb` mode.
- `WIDGETS`: optional space-separated widget list. Valid values are `sysmon`
  and `media`.
- `DESCRIPTION`: text used in notifications and the Waybar tooltip.

Every profile may also have a `hyprland.conf` file. If present, it is copied to
`~/.local/state/omarchy/toggles/hypr/autorice.conf` and Hyprland is reloaded.

## Waybar Integration

`~/dotfiles/waybar/config.jsonc` includes:

```jsonc
"custom/autorice": {
  "exec": "autorice waybar",
  "return-type": "json",
  "interval": 5,
  "signal": 11,
  "on-click": "autorice detect",
  "on-click-right": "omarchy-launch-floating-terminal-with-presentation autorice list"
}
```

The module shows a compact profile label:

- `dev` for `development`
- `present` for `presentation`
- the full profile name for other profiles

Left-click runs detection. Right-click opens a small terminal command listing
available profiles. `autorice` sends `RTMIN+11` to Waybar after applying a
profile so the widget updates immediately.

## Profiles

### development

`profiles/development/profile.conf`:

```bash
THEME=flexoki-dark
POWER_PROFILE=balanced
IDLE=on
DND=off
WIDGETS=sysmon
DESCRIPTION="dense development layout with normal notifications"
```

Development is the default profile. It keeps the current dark Flexoki theme,
balanced power, idle locking enabled, notifications enabled, and the desktop
system monitor widget visible.

`profiles/development/hyprland.conf`:

```hyprlang
general {
  gaps_in = 1
  gaps_out = 1
  border_size = 1
}

decoration {
  rounding = 0
  active_opacity = 1.0
  inactive_opacity = 0.96
}

misc {
  vfr = true
}
```

This is the densest work profile: minimal gaps, square corners, thin borders,
and slight inactive-window dimming.

### reading

`profiles/reading/profile.conf`:

```bash
THEME=flexoki-light
POWER_PROFILE=power-saver
IDLE=on
DND=on
DESCRIPTION="quiet light theme for reading and annotation"
```

Reading switches to a light theme, lowers the power profile, keeps idle locking
enabled, and silences notifications.

`profiles/reading/hyprland.conf`:

```hyprlang
general {
  gaps_in = 5
  gaps_out = 8
  border_size = 1
}

decoration {
  rounding = 6
  active_opacity = 1.0
  inactive_opacity = 0.92
}

misc {
  vfr = true
}
```

This opens the layout up slightly for documents and annotation, with rounded
corners and stronger inactive-window dimming.

### gaming

`profiles/gaming/profile.conf`:

```bash
THEME=futurism
POWER_PROFILE=performance
IDLE=off
DND=on
DESCRIPTION="performance mode with idle lock and notifications suppressed"
```

Gaming switches to the Futurism theme, requests performance power, disables
idle locking, and suppresses notifications.

`profiles/gaming/hyprland.conf`:

```hyprlang
general {
  gaps_in = 0
  gaps_out = 0
  border_size = 0
}

decoration {
  rounding = 0
  active_opacity = 1.0
  inactive_opacity = 1.0
}

misc {
  vfr = false
}
```

This removes gaps, borders, rounded corners, and opacity changes. It also turns
off Hyprland VFR for a steadier high-performance mode.

### media

`profiles/media/profile.conf`:

```bash
THEME=midnight
POWER_PROFILE=balanced
IDLE=keep
DND=off
WIDGETS=media
DESCRIPTION="media mode with now playing on the desktop"
```

Media mode keeps idle behavior unchanged, enables notifications, and starts the
now-playing widget.

`profiles/media/hyprland.conf`:

```hyprlang
general {
  gaps_in = 3
  gaps_out = 5
  border_size = 1
}

decoration {
  rounding = 5
  active_opacity = 1.0
  inactive_opacity = 0.94
}

misc {
  vfr = true
}
```

### focus

`profiles/focus/profile.conf`:

```bash
THEME=midnight
POWER_PROFILE=balanced
IDLE=on
DND=on
DESCRIPTION="low-distraction dark theme for focused work"
```

Focus uses a darker theme, balanced power, idle locking, and DND.

`profiles/focus/hyprland.conf`:

```hyprlang
general {
  gaps_in = 2
  gaps_out = 3
  border_size = 1
}

decoration {
  rounding = 3
  active_opacity = 1.0
  inactive_opacity = 0.88
}

misc {
  vfr = true
}
```

This keeps the layout compact while making inactive windows recede more than in
development mode.

### presentation

`profiles/presentation/profile.conf`:

```bash
THEME=osaka-jade
POWER_PROFILE=balanced
IDLE=off
DND=on
DESCRIPTION="stable presentation mode with screen lock avoided"
```

Presentation mode avoids idle locking, silences notifications, and uses a
balanced power profile so screen sharing or demos are less likely to be
interrupted.

`profiles/presentation/hyprland.conf`:

```hyprlang
general {
  gaps_in = 4
  gaps_out = 6
  border_size = 2
}

decoration {
  rounding = 4
  active_opacity = 1.0
  inactive_opacity = 0.96
}

misc {
  vfr = false
}
```

This profile uses visible borders and moderate spacing so windows are easier to
track during demos.

## Adding A Profile

1. Create `profiles/<name>/profile.conf`.
2. Optionally create `profiles/<name>/hyprland.conf`.
3. Add keywords for it in the `classify` function in
   `personal_scripts/autorice`.
4. Run `autorice apply <name>`.

The profile name should match the directory name exactly.
