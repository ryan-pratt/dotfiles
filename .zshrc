# ====================== PREREQUISITES ====================== 
# bat (cat replacement)
# eza (ls replacement)
# fzf (fuzzy finder for files & command history)
# git-delta (pager for git and diff)
# lazygit (TUI for git)
# neovim (editor)
# npm (for default LSP config in neovim)
# oh-my-posh (prompt eye candy)
# ripgrep (for project search in neovim)
# z (cd replacement)
# ========================== SETUP ========================== 
# 0. clone into ~/dotfiles
# 1. install the above prereqs and the font file in this dir
# 2. `stow .` in this dir
# 3. neovim should automatically install all plugins on first launch
# 4. open lazygit, then open its config file by pressing 1 then e, and add this:
# git:
#   paging:
#     colorArg: always
#     pager: delta --dark --paging=never --hyperlinks --line-numbers --side-by-side
# ========================== TODOS ========================== 
# - [ ] figure out a way to not have to do that lazygit configuration manually
# - [ ] see if I can add Obsidian preferences (and maybe even plugins?)
# ===========================================================

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby@3.2/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
export PATH="/Users/rpratt/repos/cosmos:$PATH"
ulimit -n 4096

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config '~/.oh-my-posh.toml')"
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias fv=“fzf —print0 | xargs -0 -o nvim”

# from https://github.com/MohamedElashri/exa-zsh/blob/main/exa-zsh.plugin.zsh
alias ls='eza' # just replace ls by exa and allow all other exa arguments
alias l='ls -lbF' #   list, size, type
alias ll='ls -la' # long, all
alias llm='ll --sort=modified' # list, long, sort by modification date
alias la='ls -lbhHigUmuSa' # all list
alias lx='ls -lbhHigUmuSa@' # all list and extended
alias tree='eza --tree' # tree view
alias lS='eza -1' # one column by just names
alias cat='bat'
alias fc='cat $(fzf)'
alias rd='rm -rd'
alias rdf='rm -rdf'

alias vim='nvim'
alias nv='nvim'
alias fv='nvim $(fzf)'

alias lg='lazygit'

alias y='yarn'
alias yb='yarn build'
alias oc3='openc3.sh'


eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
