# FONT USED BELOW - BANNER 3D
# https://patorjk.com/software/taag/#p=display&h=2&f=Banner3-D&t=text%0A

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/antigen/antigen.zsh"
antigen init "$HOME/.antigenrc"

export PATH="/usr/local/bin:$PATH" 
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/$HOME/Library/Android/sdk/platform-tools"
export PATH="/opt/homebrew/bin:$PATH"

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

## colorful cat alternative
alias bat="bat -p"
alias cat="bat"

alias zshrc="code ~/.zshrc"
alias atgrc="code ~/.dotfiles/.antigenrc"
## reload source
alias rc="source ~/.zshrc"
alias c="clear"
## close terminal
alias x="exit"

## Directories Lookup
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
alias -g G='| grep -i'

## Network
alias localip="ipconfig getifaddr en0"

## Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

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
## Speciality views
alias lS='exa -1'			                                                  # one column, just names
alias lt='exa --tree --level=2'                                         # tree

## System
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
alias y="yarn"
alias yd="yarn dev"
alias ya="yarn android"

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
alias nu="npm unpublish" 

# '########::'##::::'##:'########::
#  ##.... ##: ##:::: ##: ##.... ##:
#  ##:::: ##: ##:::: ##: ##:::: ##:
#  ########:: #########: ########::
#  ##.....::: ##.... ##: ##.....:::
#  ##:::::::: ##:::: ##: ##::::::::
#  ##:::::::: ##:::: ##: ##::::::::
# ..:::::::::..:::::..::..:::::::::
## Development
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
## Harbor PHP Artisan
alias hba="./harbor art"
alias hbac="./harbor art cache:clear"
alias hbaoc="./harbor art optimize:clear"
alias hbst='./harbor stop'

## Composer
alias ci="composer install"
alias ci:ignore="composer install --ignore-platform-reqs"

## Sail
alias sail="./vendor/bin/sail"
alias sa="sail artisan"
alias sakg="sail artisan key:generate"
alias sam="sail artisan migrate"
alias sc="sail composer"
alias cpenv="cp .env.example .env"

## Utilities
## Get beautiful weather reporting 
alias weather="curl wttr.in"

## Servers
alias sauron="ssh forge@167.99.142.20"
alias smaug="ssh forge@157.230.28.157"
alias globalfinance="ssh forge@167.71.35.124"

## ZSH VIM Settings
## Only changing the escape key to `jk` in insert mode, we still
## keep using the default keybindings `^[` in other modes
ZVM_VI_ESCAPE_BINDKEY=jk


# '########:'##::::'##:'##::: ##::'######::'########:'####::'#######::'##::: ##::'######::
#  ##.....:: ##:::: ##: ###:: ##:'##... ##:... ##..::. ##::'##.... ##: ###:: ##:'##... ##:
#  ##::::::: ##:::: ##: ####: ##: ##:::..::::: ##::::: ##:: ##:::: ##: ####: ##: ##:::..::
#  ######::: ##:::: ##: ## ## ##: ##:::::::::: ##::::: ##:: ##:::: ##: ## ## ##:. ######::
#  ##...:::: ##:::: ##: ##. ####: ##:::::::::: ##::::: ##:: ##:::: ##: ##. ####::..... ##:
#  ##::::::: ##:::: ##: ##:. ###: ##::: ##:::: ##::::: ##:: ##:::: ##: ##:. ###:'##::: ##:
#  ##:::::::. #######:: ##::. ##:. ######::::: ##::::'####:. #######:: ##::. ##:. ######::
# ..:::::::::.......:::..::::..:::......::::::..:::::....:::.......:::..::::..:::......:::

## Cheatshet for everything you need
## For example you forgot how to use map-like function for Objects
## cht js/map+object
## or forgot how to list directory 
## cht ls
function cht() {
  if [ -n "$1" ]; then
    curl cht.sh/$1
  else
    echo $c[bold] $c[bg_bright_blue] "⚠️  Your search query is missing  🔍" $c[reset]
  fi
}

# '########:::::'###::::'########:'##::::'##::'######::
#  ##.... ##:::'## ##:::... ##..:: ##:::: ##:'##... ##:
#  ##:::: ##::'##:. ##::::: ##:::: ##:::: ##: ##:::..::
#  ########::'##:::. ##:::: ##:::: #########:. ######::
#  ##.....::: #########:::: ##:::: ##.... ##::..... ##:
#  ##:::::::: ##.... ##:::: ##:::: ##:::: ##:'##::: ##:
#  ##:::::::: ##:::: ##:::: ##:::: ##:::: ##:. ######::
# ..:::::::::..:::::..:::::..:::::..:::::..:::......:::

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PNPM_HOME="/Users/stanislav.varga/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

# '########:'########:'########::'##::::'##:'####:'##::: ##::::'###::::'##:::::::
# ... ##..:: ##.....:: ##.... ##: ###::'###:. ##:: ###:: ##:::'## ##::: ##:::::::
# ::: ##:::: ##::::::: ##:::: ##: ####'####:: ##:: ####: ##::'##:. ##:: ##:::::::
# ::: ##:::: ######::: ########:: ## ### ##:: ##:: ## ## ##:'##:::. ##: ##:::::::
# ::: ##:::: ##...:::: ##.. ##::: ##. #: ##:: ##:: ##. ####: #########: ##:::::::
# ::: ##:::: ##::::::: ##::. ##:: ##:.:: ##:: ##:: ##:. ###: ##.... ##: ##:::::::
# ::: ##:::: ########: ##:::. ##: ##:::: ##:'####: ##::. ##: ##:::: ##: ########:
# :::..:::::........::..:::::..::..:::::..::....::..::::..::..:::::..::........::
## ATUIN - A CLI for your shell history
alias h="atuin"
alias hs="atuin search -i" #interative history search
alias hsf="atuin search --exclude-exit 0 -i" #failed commands
alias hss="atuin search --exit 0 -i" # successful commands

# :'######:::'######::'########::'####:'########::'########::'######::
# '##... ##:'##... ##: ##.... ##:. ##:: ##.... ##:... ##..::'##... ##:
#  ##:::..:: ##:::..:: ##:::: ##:: ##:: ##:::: ##:::: ##:::: ##:::..::
# . ######:: ##::::::: ########::: ##:: ########::::: ##::::. ######::
# :..... ##: ##::::::: ##.. ##:::: ##:: ##.....:::::: ##:::::..... ##:
# '##::: ##: ##::: ##: ##::. ##::: ##:: ##::::::::::: ##::::'##::: ##:
# . ######::. ######:: ##:::. ##:'####: ##::::::::::: ##::::. ######::
# :......::::......:::..:::::..::....::..::::::::::::..::::::......:::
source "$HOME/.zsh.init" 
# eval "$(oh-my-posh init zsh --config $DOTFILES/oh-my-posh/amro.omp.json)"
eval "$(oh-my-posh init zsh --config $DOTFILES/oh-my-posh/robbyrussel.omp.json)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

## Reloads for various configs
alias reload:icons="zx ~/.dotfiles/macos/dock-icons.mjs"
alias r:icons="zx ~/.dotfiles/macos/dock-icons.mjs"
alias reload:zsh="source ~/.zshrc"
alias r:zsh="source ~/.zshrc"

