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
    presentation/
      profile.conf
      hyprland.conf
    reading/
      profile.conf
      hyprland.conf
personal_scripts/
  autorice
```

The executable is `~/dotfiles/personal_scripts/autorice`. The profile directory
is `~/dotfiles/autorice/profiles`.

## Commands

```bash
autorice apply "reading papers"
autorice apply development
autorice detect
autorice status
autorice list
autorice waybar
```

- `apply <text|profile>` classifies the text, loads the matching profile, and
  applies it.
- `detect` reads the active Hyprland window class/title and selected process
  hints, then applies the inferred profile.
- `status` prints the last applied profile, theme, request, and timestamp.
- `list` prints available profile names.
- `waybar` prints JSON for Waybar's `custom/autorice` module.

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
DESCRIPTION="dense development layout with normal notifications"
```

- `THEME`: Omarchy theme name passed to `omarchy-theme-set`.
- `POWER_PROFILE`: value passed to `powerprofilesctl set`, if available.
- `IDLE`: `on`, `off`, or `keep`; controls `hypridle`.
- `DND`: `on`, `off`, or `keep`; controls Mako's `do-not-disturb` mode.
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
DESCRIPTION="dense development layout with normal notifications"
```

Development is the default profile. It keeps the current dark Flexoki theme,
balanced power, idle locking enabled, and notifications enabled.

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
