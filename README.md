# Arch dotfiles for Omarchy

This repository is the editable source of truth for personal configuration on an
Arch system running [Omarchy](https://omarchy.org/).

Omarchy's distro checkout remains at `~/.local/share/omarchy`. That path is
still used by Omarchy commands through `$OMARCHY_PATH`, so it should be left in
place for updates, defaults, migrations, and built-in scripts.

The user-owned live config is kept here in `~/dotfiles` and symlinked back to
the locations that Omarchy and the desktop expect.

## Setup

On a new system, set up git SSH keys, clone this repository into `~/dotfiles`,
then create the symlinks below.

```bash
ln -s ~/dotfiles/hypr ~/.config/hypr
ln -s ~/dotfiles/ghostty ~/.config/ghostty
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/omarchy ~/.config/omarchy
ln -s ~/dotfiles/waybar ~/.config/waybar
ln -s ~/dotfiles/swayosd ~/.config/swayosd
ln -s ~/dotfiles/btop ~/.config/btop
ln -s ~/dotfiles/sublime ~/.config/sublime-text/Packages/User

ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/bashrc ~/.bashrc
ln -s ~/dotfiles/aliases ~/.aliases
ln -s ~/dotfiles/pathrc ~/.pathrc
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/pythonstartup ~/.pythonstartup
```

`pathrc` is intentionally ignored because it contains local paths and secrets.

## Layout

- `hypr/`: Hyprland config layered on top of Omarchy defaults. It keeps the
  compact workspace setup, Vim-style navigation, caps-to-control input changes,
  tabbed/grouped window bindings, and runtime toggle include path.
- `omarchy/`: User Omarchy state and custom themes. This is symlinked to
  `~/.config/omarchy`, while Omarchy's upstream checkout stays at
  `~/.local/share/omarchy`.
- `waybar/`: Waybar config, theme import, and the `autorice` status module.
- `swayosd/`: SwayOSD config and style.
- `btop/`: btop config and current theme link.
- `ghostty/`: Ghostty terminal config.
- `nvim/`: Active LazyVim configuration and plugin lockfile.
- `personal_scripts/`: Small commands that should be available on `$PATH`,
  including `autorice`.
- `autorice/`: Task-aware ricing prototype. See `autorice/README.md`.
- `sublime/`: Sublime Text user preferences, keymaps, and snippets.
- `bashrc`, `aliases`, `gitconfig`, `tmux.conf`, `vimrc`, and `zathurarc`:
  Shell, terminal, editor, and app configs.

## Omarchy Integration

The system uses two layers:

1. `~/.local/share/omarchy` is Omarchy's own install tree. It provides commands
   such as `omarchy-theme-set`, default configs, migrations, and built-in
   themes.
2. `~/dotfiles` owns the user config layer. Symlinks from `~/.config/*` point
   back here so the OS reads the expected paths while edits stay versioned in
   this repo.

Do not move the entire Omarchy checkout into this repo. Keeping the upstream
tree separate avoids breaking `$OMARCHY_PATH` and keeps Omarchy updates
straightforward.

## Autorice

`autorice` is the prototype for a natural-language, task-aware ricing system.
It maps instructions such as "reading papers", "coding", "gaming", or
"presentation mode" onto:

- an Omarchy theme
- Hyprland runtime overrides
- state-specific desktop widgets
- notification do-not-disturb state
- idle locking behavior
- power profile
- Waybar status text

Examples:

```bash
autorice apply "reading papers"
autorice "bright sunshine work"
autorice apply gaming
autorice apply "dim ui with a web browser on the left and terminal plus sublime stacked on the right"
autorice detect
autorice status
autorice check
```

`autorice detect` uses the active Hyprland window and selected process hints to
infer the current task. The generated Hyprland override is written to
`~/.local/state/omarchy/toggles/hypr/autorice.conf`, which is already sourced by
`hypr/hyprland.conf`.

`autorice check` walks every profile sequentially and verifies the configured
theme, power profile, idle setting, DND setting, description, Hyprland override,
and runtime dependency availability. Optional integrations are guarded in the
script, so missing tools report a warning and the related step is skipped rather
than aborting the whole profile apply.

For natural-language requests, `autorice apply <text>` wraps `codex exec` in
read-only mode with a strict JSON schema. Codex only produces a plan; the local
`autorice` script validates and applies that plan using its allowlisted themes,
Hyprland settings, and app launchers. Exact profile names such as
`autorice apply gaming` still apply locally without Codex.

`Ctrl+Super+Space` is rebound from Omarchy's background menu to a generic
ephemeral terminal. It behaves like a normal terminal, but if you run a
natural-language `autorice` request inside it, `autorice` closes that source
terminal after applying the requested layout.

Freeform layouts apply to the workspace where `autorice` is invoked,
unless the request explicitly names another workspace or desktop.

State profiles can also start widgets. `autorice dev` starts a small
development monitor, while `autorice media` starts a now-playing widget powered
by `playerctl`. Changing to a profile without widgets clears the previous
autorice widgets. The widgets use GTK layer-shell on the compositor bottom
layer, so normal app windows cover them instead of the widgets covering apps.

## Current Differences From Base Omarchy

- tmux-oriented terminal workflow
- Vim-style Hyprland navigation with `hjkl`
- smaller gaps and borders for denser workspaces
- caps lock mapped to control
- Hyprland tabbed/grouped window bindings
- user Omarchy, Waybar, SwayOSD, and btop config versioned in dotfiles
- `autorice` task-aware theme/layout prototype
