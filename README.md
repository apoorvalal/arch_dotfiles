## dotfiles for arch system running omarchy

On a new system, set up git ssh keys, and then git clone into `~/dotfiles`.
Then symlink into the right places; e.g 
- `ln -s ~/dotfiles/hypr ~/.config/hypr` : hyprland config for omarchy
- `ln -s ~/dotfiles/vimrc ~/.vimrc` : vimrc
- `ln -s ~/dotfiles/bashrc ~/.bashrc` : bash config
- `ln -s ~/dotfiles/aliases ~/.aliases` : bash shortcuts
- `ln -s ~/dotfiles/pathrc ~/.pathrc` : path and api keys [obv not putting this file here, thieves]

and so on.
