# Load Antigen

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/antigen.zsh"
# source "$DOTFILES/system/.links.zsh"

# Load Antigen configurations
antigen init "$HOME/.dotfiles/.antigenrc"

# Export preffered paths
export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/opt/homebrew/bin/node"

# Aliases
alias reload="source ~/.zshrc"
alias zshconfig="vim ~/.zshrc"
alias ezsh="code ~/.zshrc"
alias eantigen="code ~/.zshrc"

# EXA Aliases
alias ls='exa'                                                         # ls
alias l='exa -lbF --git'                                               # list, size, type, git
alias ll='exa -lbGF --git'                                             # long list
alias llm='exa -lbGF --git --sort=modified'                            # long list, modified date sort
alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# speciality views
alias lS='exa -1'			                                                  # one column, just names
alias lt='exa --tree --level=2'                                         # tree

alias c="clear"
alias x="exit" # close terminal
alias e="code -n ~/.zshrc" # edit source
alias r="source ~/.zshrc" # reload source
alias t="htop"

# NPM Aliases
alias rnm="rm -rf node_modules"
alias rbn="rm -rf build node_modules"
alias rap="rm -rf build coverage node_modules package-lock.json && npm i"

alias npk="npx npkill"
alias nlg="npm list -g --depth 0"

alias ni="npm i"
alias nis="npm i -S " 
alias nise="npm i -S -E " 
alias nid="npm i -D " 
alias nide="npm i -D -E " 
alias nr="npm r " 

alias nrb="npm run build"
alias nrbd="npm run build:dev"
alias nrbq="npm run build:qa"
alias nrs="npm run start"
alias nrw="npm run watch"
alias nrsd="npm run start:dev"
alias nrsq="npm run start:qa"
alias nrt="npm run test"
alias nrtc="npm run test:c" 

alias np="npm run build && npm publish"
alias nu="npm unpublish " 

# System
alias runp='lsof -ni'
alias sshdir='cd ~/.ssh'
alias rm='trash'

# Development
alias hb="./harbor"
alias hbs="./harbor start"
alias hbr="./harbor rebuild"
alias hbriv="./harbor rebuild -iv"



# Directories Lookup
d='dirs -v | head -10'
1='cd -'
2='cd -2'
3='cd -3'
4='cd -4'
5='cd -5'
6='cd -6'
7='cd -7'
8='cd -8'
9='cd -9'
# Files lookup
grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias -g G='| grep -i'

# Project Related aliases
# You can easily switch between them, just write upw, upa without any other command
# Oh-My-ZSH will automatically assume that you want to cd into directory, given you pass it as command

alias bra='$HOME/Documents/brackets'
alias upw='$HOME/Documents/brackets/up-korporatny-web'
alias upa='$HOME/Documents/brackets/up-cms-api'

# Utilities

## Get beautiful weather reporting 
alias weather="curl wttr.in"



## ZSH VIM Settings
# Only changing the escape key to `jk` in insert mode, we still
# keep using the default keybindings `^[` in other modes
ZVM_VI_ESCAPE_BINDKEY=jk


## Cheatshet for everything you need
## For example you forgot how to use map-like function for Objects
## cht js/map+object
function cht() {
  if [ -n "$1" ]; then
    curl cht.sh/$1
  else
    echo $c[bold] $c[bg_bright_blue] "⚠️  Your search query is missing  🔍" $c[reset]
  fi
}


# Functions
# fh - search in your command history and execute selected command
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

npm() {
  if [ -e yarn.lock ]; then
    echo "⚠️ This is a yarn project. Why don't you use it ⁉️"
  else
    command npm $@
  fi
}

yarn() {
  if [ -e package-lock.json ]; then
    echo $c[bold] $c[bg_bright_blue] ⚠️ This is a npm project. Why don\'t you use it ⁉️ $c[reset]
  else
    command npm $@
  fi
}