## dotfiles for arch system running [omarchy](https://omarchy.org/)

On a new system, set up git ssh keys, and then git clone into `~/dotfiles`.
Then symlink into the right places; e.g 
- `ln -s ~/dotfiles/hypr ~/.config/hypr` : hyprland config for omarchy
- `ln -s ~/dotfiles/vimrc ~/.vimrc` : vimrc
- `ln -s ~/dotfiles/bashrc ~/.bashrc` : bash config
- `ln -s ~/dotfiles/aliases ~/.aliases` : bash shortcuts
- `ln -s ~/dotfiles/pathrc ~/.pathrc` : path and api keys [obv not putting this file here, thieves]

and so on.

Over base omarchy, this has
1) tmux - like having terminals be in one desktop and create panes there if necessary
2) better vim navigation in hyprland: hjkl switch panes as they should
3) smaller gaps - never understood why ricers like to waste space 
4) caps lock mapped to ctrl
5) adds hyprland tabbed mode and ways to move windows in and out of them.  
