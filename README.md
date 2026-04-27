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
- `personal_scripts/`: Small commands that should be available on `$PATH`,
  including `autorice`.
- `autorice/`: Task-aware ricing prototype. See `autorice/README.md`.
- `sublime/`: Sublime Text user preferences, keymaps, and snippets.
- `bashrc`, `aliases`, `tmux.conf`, `vimrc`, `init.lua`, `init.vim`,
  `zathurarc`: Shell, terminal, editor, and app configs.

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
- notification do-not-disturb state
- idle locking behavior
- power profile
- Waybar status text

Examples:

```bash
autorice apply "reading papers"
autorice apply gaming
autorice detect
autorice status
```

`autorice detect` uses the active Hyprland window and selected process hints to
infer the current task. The generated Hyprland override is written to
`~/.local/state/omarchy/toggles/hypr/autorice.conf`, which is already sourced by
`hypr/hyprland.conf`.

## Current Differences From Base Omarchy

- tmux-oriented terminal workflow
- Vim-style Hyprland navigation with `hjkl`
- smaller gaps and borders for denser workspaces
- caps lock mapped to control
- Hyprland tabbed/grouped window bindings
- user Omarchy, Waybar, SwayOSD, and btop config versioned in dotfiles
- `autorice` task-aware theme/layout prototype
