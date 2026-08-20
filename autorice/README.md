# Autorice

`autorice` is a task-aware desktop profile switcher for Omarchy 4. It accepts a
named profile or a natural-language request and applies a coordinated theme,
Hyprland layout, notification, idle, power, and widget state.

## What It Controls

- Omarchy themes through `omarchy-theme-set`
- Hyprland 0.56 runtime overrides through `hl.config()` Lua files
- QuickShell notification do-not-disturb state through `omarchy-shell`
- Omarchy idle inhibition through `omarchy-toggle-idle`
- power mode through `powerprofilesctl`
- a QuickShell bar status module in `~/.config/omarchy/shell.json`
- optional GTK layer-shell desktop widgets

## Commands

```bash
autorice apply development
autorice apply "reading papers"
autorice describe "dim UI with a browser and editor"
autorice codex-plan "quiet browser and editor layout"
autorice detect
autorice status
autorice check
autorice list
autorice bar
```

- `apply <profile>` applies an exact local profile.
- `apply <text>` asks the constrained Codex planner for a plan, then applies it.
- `autorice <text>` is shorthand for `autorice apply <text>`.
- `detect` chooses a profile from the active window and selected process hints.
- `status` prints the last applied state.
- `check` validates dependencies and all profile files.
- `bar` prints Waybar-compatible JSON for Omarchy 4's QuickShell command module.
  `waybar` remains as a compatibility alias.

## Files

```text
autorice/
  codex-plan.schema.json
  profiles/<name>/
    profile.conf
    hyprland.lua
personal_scripts/
  autorice
  autorice-widget
omarchy/
  bar/modules/autorice.qml
  bar/modules/cpu.qml
  shell.json
```

Generated state stays out of git:

- `~/.local/state/autorice/current` contains the last applied profile metadata.
- `~/.local/state/omarchy/toggles/hypr/autorice.lua` is the active generated
  Hyprland override. Omarchy 4 loads this directory after its defaults.

## Profile Format

Each `profiles/<name>/profile.conf` is sourced as Bash:

```bash
THEME=flexoki-dark
POWER_PROFILE=balanced
IDLE=on
DND=off
WIDGETS=sysmon
DESCRIPTION="dense development layout with normal notifications"
```

- `THEME` must name an installed Omarchy or user theme.
- `POWER_PROFILE` is `balanced`, `performance`, or `power-saver`.
- `IDLE=on` allows normal idle lock/screensaver behavior, `off` keeps the
  machine awake, and `keep` leaves the current state alone.
- `DND=on` silences QuickShell notifications, `off` enables them, and `keep`
  leaves the current state alone.
- `WIDGETS` is an optional space-separated list containing `sysmon` or `media`.
- `DESCRIPTION` is used in notifications and the bar tooltip.

The optional `hyprland.lua` contains the profile's Hyprland overrides:

```lua
hl.config({
  general = {
    gaps_in = 1,
    gaps_out = 1,
    border_size = 1,
  },
  decoration = {
    rounding = 0,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
  },
})
```

## Included Profiles

| Profile | Theme | Power | Idle | DND | Widget |
|---|---|---|---|---|---|
| `development` | `flexoki-dark` | balanced | on | off | sysmon |
| `focus` | `midnight` | balanced | on | on | — |
| `gaming` | `futurism` | performance | off | on | — |
| `media` | `midnight` | balanced | keep | off | media |
| `presentation` | `osaka-jade` | balanced | off | on | — |
| `reading` | `flexoki-light` | power-saver | on | on | — |

## QuickShell Bar Integration

`~/.config/omarchy/shell.json` includes the custom QML module
`omarchy/bar/modules/autorice.qml` in the center section. It runs `autorice bar`
every five seconds. Left-click applies a profile inferred from the active
window; right-click opens the profile list in a floating terminal.

The module prints a compact label (`dev`, `present`, or the profile name) and a
tooltip with the last request, description, and theme.

## Optional Desktop Widgets

`autorice-widget` manages two GTK layer-shell widgets:

```bash
autorice-widget restart sysmon
autorice-widget restart media
autorice-widget stop
```

`sysmon` shows load, memory, disk, and temperature. `media` reads now-playing
metadata directly from MPRIS over the session bus, with no `playerctl`
dependency. Both sit on the desktop layer below normal windows.

## Codex Planner

Freeform requests run Codex read-only with
`autorice/codex-plan.schema.json`. Codex can only return constrained JSON; the
local script validates and applies it. Exact profile names do not call Codex.

The app allowlist is deliberately small: `browser`, `terminal`, `sublime`, and
`editor`. Freeform layouts default to the active workspace unless the request
explicitly names another one, such as `workspace 4`.

`Ctrl+Super+Space` opens an ephemeral terminal. When Autorice is invoked from
that terminal, it hides or closes only that source terminal while arranging the
requested apps.

## Adding a Profile

1. Create `profiles/<name>/profile.conf`.
2. Optionally add `profiles/<name>/hyprland.lua` using `hl.config()` syntax.
3. Add classifier keywords in `personal_scripts/autorice` if detection should
   select it.
4. Run `autorice check`, then `autorice apply <name>`.
