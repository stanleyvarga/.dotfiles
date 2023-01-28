# AWESOME FONTS
# https://patorjk.com/software/taag/#p=display&h=2&f=Banner3-D&t=text%0A
# FONT USED BELOW - BANNER 3D

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
# export PATH="$PATH:/opt/homebrew/bin/node"
export PATH="$PATH:/$HOME/.nvm/versions/node/v16.14.2/bin/node"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/$HOME/Library/Android/sdk/platform-tools"

# :'######:::'########:'##::: ##:'########:'########:::::'###::::'##::::::::::::'###::::'##:::::::'####::::'###:::::'######::'########::'######::
# '##... ##:: ##.....:: ###:: ##: ##.....:: ##.... ##:::'## ##::: ##:::::::::::'## ##::: ##:::::::. ##::::'## ##:::'##... ##: ##.....::'##... ##:
#  ##:::..::: ##::::::: ####: ##: ##::::::: ##:::: ##::'##:. ##:: ##::::::::::'##:. ##:: ##:::::::: ##:::'##:. ##:: ##:::..:: ##::::::: ##:::..::
#  ##::'####: ######::: ## ## ##: ######::: ########::'##:::. ##: ##:::::::::'##:::. ##: ##:::::::: ##::'##:::. ##:. ######:: ######:::. ######::
#  ##::: ##:: ##...:::: ##. ####: ##...:::: ##.. ##::: #########: ##::::::::: #########: ##:::::::: ##:: #########::..... ##: ##...:::::..... ##:
#  ##::: ##:: ##::::::: ##:. ###: ##::::::: ##::. ##:: ##.... ##: ##::::::::: ##.... ##: ##:::::::: ##:: ##.... ##:'##::: ##: ##:::::::'##::: ##:
# . ######::: ########: ##::. ##: ########: ##:::. ##: ##:::: ##: ########::: ##:::: ##: ########:'####: ##:::: ##:. ######:: ########:. ######::
# :......::::........::..::::..::........::..:::::..::..:::::..::........::::..:::::..::........::....::..:::::..:::......:::........:::......:::
alias dev="cd ~/Documents/devspace"
alias work="cd ~/Documents/brackets"

alias bat="bat -p"

# '########:'########:'########::'##::::'##:'####:'##::: ##::::'###::::'##:::::::
# ... ##..:: ##.....:: ##.... ##: ###::'###:. ##:: ###:: ##:::'## ##::: ##:::::::
# ::: ##:::: ##::::::: ##:::: ##: ####'####:: ##:: ####: ##::'##:. ##:: ##:::::::
# ::: ##:::: ######::: ########:: ## ### ##:: ##:: ## ## ##:'##:::. ##: ##:::::::
# ::: ##:::: ##...:::: ##.. ##::: ##. #: ##:: ##:: ##. ####: #########: ##:::::::
# ::: ##:::: ##::::::: ##::. ##:: ##:.:: ##:: ##:: ##:. ###: ##.... ##: ##:::::::
# ::: ##:::: ########: ##:::. ##: ##:::: ##:'####: ##::. ##: ##:::: ##: ########:
# :::..:::::........::..:::::..::..:::::..::....::..::::..::..:::::..::........::

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

## Files lookup
grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

## A few useful aliases
alias awk1="awk '{print \$1}'"
alias awk2="awk '{print \$2}'"
alias awk3="awk '{print \$3}'"
alias awk4="awk '{print \$4}'"

## Network
alias localip="ipconfig getifaddr en0"

## GIT
## Git Push to Current Origin and set upstream current branch
alias gpo="git push --set-upstream origin"
alias gb='git branch'
alias gco='git checkout'


## EXA Aliases
alias ls='exa'                                                         # ls
alias l='exa -lbF --git'                                               # list, size, type, git
alias ll='exa -lbGF --git'                                             # long list
alias llm='exa -lbGF --git --sort=modified'                            # long list, modified date sort
alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

## speciality views
alias lS='exa -1'			                                                  # one column, just names
alias lt='exa --tree --level=2'                                         # tree

alias -g G='| grep -i'
alias zshrc="code ~/.zshrc"
alias atgrc="code ~/.dotfiles/.antigenrc"
alias c="clear"
alias x="exit" # close terminal
alias e="code -n ~/.zshrc" # edit source
alias r="source ~/.zshrc" # reload source
alias t="htop"

# System
alias runp='lsof -ni'
alias sshdir='cd ~/.ssh'
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias rm='trash'

# '##::: ##:'########::'#######::'##::::'##:'####:'##::::'##:
#  ###:: ##: ##.....::'##.... ##: ##:::: ##:. ##:: ###::'###:
#  ####: ##: ##::::::: ##:::: ##: ##:::: ##:: ##:: ####'####:
#  ## ## ##: ######::: ##:::: ##: ##:::: ##:: ##:: ## ### ##:
#  ##. ####: ##...:::: ##:::: ##:. ##:: ##::: ##:: ##. #: ##:
#  ##:. ###: ##::::::: ##:::: ##::. ## ##:::: ##:: ##:.:: ##:
#  ##::. ##: ########:. #######::::. ###::::'####: ##:::: ##:
# ..::::..::........:::.......::::::...:::::....::..:::::..::
alias vim="nvim"
alias vimrc="nvim ~/.dotfiles/nvim/.nvimrc"

# '##::: ##:'########::'##::::'##:
#  ###:: ##: ##.... ##: ###::'###:
#  ####: ##: ##:::: ##: ####'####:
#  ## ## ##: ########:: ## ### ##:
#  ##. ####: ##.....::: ##. #: ##:
#  ##:. ###: ##:::::::: ##:.:: ##:
#  ##::. ##: ##:::::::: ##:::: ##:
# ..::::..::..:::::::::..:::::..::
alias rnm="rm -rf node_modules package-json.lock"
alias rbn="rm -rf build node_modules"
alias rap="rm -rf build coverage node_modules package-lock.json && npm i"

alias npk="npx npkill"
alias nlg="npm list -g --depth 0"

alias ni="npm i"
alias nis="npm i -S"
alias nise="npm i -S -E"
alias nid="npm i -D"
alias nide="npm i -D -E" 
alias nr="npm r" 

alias nrt:w="npm run test:watch"
alias nrb="npm run build"
alias nrd="npm run dev"
alias nrbd="npm run build:dev"
alias nrbq="npm run build:qa"
alias nrs="npm run start"
alias nrw="npm run watch"
alias nrh="npm run hot"
alias nrsd="npm run start:dev"
alias nrsq="npm run start:qa"
alias nrt="npm run test"
alias nrt:ci="npm run test:ci" 
alias nrt:ciu="npm run test:ci -- -u" 
alias nrck="npm run check" 

alias np="npm run build && npm publish"
alias nu="npm unpublish " 

# '########::'##::::'##:'########::
#  ##.... ##: ##:::: ##: ##.... ##:
#  ##:::: ##: ##:::: ##: ##:::: ##:
#  ########:: #########: ########::
#  ##.....::: ##.... ##: ##.....:::
#  ##:::::::: ##:::: ##: ##::::::::
#  ##:::::::: ##:::: ##: ##::::::::
# ..:::::::::..:::::..::..:::::::::
# Development
alias hb="./harbor"
alias hbi="./harbor init"
alias hbs="./harbor start"
alias hbr="./harbor rebuild"
alias hbriv="./harbor rebuild -iv"
alias hbci="./harbor composer install"
alias hbam="./harbor artisan migrate"
alias hbam:f="./harbor artisan migrate:fresh"
alias hbam:fs="./harbor artisan migrate:fresh --seed"
alias hbam:s="./harbor artisan db:seed"

# Harbor PHP Artisan
alias hba="./harbor art"
alias hbac="./harbor art cache:clear"
alias hbaoc="./harbor art optimize:clear"
alias hbst='./harbor stop'

# Composer
alias ci="composer install"
alias ci:ignore="composer install --ignore-platform-reqs"

# Sail
alias sail="./vendor/bin/sail"
alias sa="sail artisan"
alias sakg="sail artisan key:generate"
alias sam="sail artisan migrate"
alias sc="sail composer"

alias cpenv="cp .env.example .env"

# Utilities
## Get beautiful weather reporting 
alias weather="curl wttr.in"

# Servers
alias sauron="ssh forge@167.99.142.20"
alias smaug="ssh forge@157.230.28.157"

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


# '########:'########:'########:
#  ##.....::..... ##:: ##.....::
#  ##::::::::::: ##::: ##:::::::
#  ######:::::: ##:::: ######:::
#  ##...:::::: ##::::: ##...::::
#  ##:::::::: ##:::::: ##:::::::
#  ##::::::: ########: ##:::::::
# ..::::::::........::..::::::::

# ag (silversearcher-ag) is a faster grep
# I recommend using it if you have to deal with large codebases
# Install it by running `sudo apt-get install silversearcher-ag`
# The variable below makes it a default command to be used by
# fzf for a file path search
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Functions
# fh - search in your command history and execute selected command
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/stanislav.varga/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end