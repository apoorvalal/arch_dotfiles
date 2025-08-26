# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

source ~/.aliases
source ~/.pathrc

# bookmark script
source ~/dotfiles/bashmarks.sh

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
# Use VSCode instead of neovim as your default editor
# export EDITOR="code"
#
# Set a custom prompt with the directory revealed (alternatively use https://starship.rs)
PS1="\W \[\e]0;\w\a\]$PS1"

# LS_COLORS=$LS_COLORS:'ow=37;42:'
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"


if [[ -f ~/.dircolors ]] ;
    then eval $(dircolors -b ~/.dircolors)
elif [[ -f /etc/DIR_COLORS ]] ; then
    eval $(dircolors -b /etc/DIR_COLORS)
fi

# FZF settings
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30


## NNN stuff
export NNN_DE_FILE_MANAGER=nemo
export NNN_TRASH=1
export NNN_FIFO=/tmp/nnn.fifo

export NNN_PLUG='f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'

nnn_cd(){
  if ! [ -z "$NNN_PIPE" ]; then
    printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" !&
    fi  
  }
trap nnn_cd EXIT

n () {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}



. "$HOME/.local/share/../bin/env"

# ~/.bashrc

eval "$(starship init bash)"
export PATH="/home/alal/.pixi/bin:$PATH"
