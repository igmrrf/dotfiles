# System

## lsd
abbr --add ls "lsd -l1"
abbr --add l "lsd -l"

abbr --add v nvim
abbr --add lv "NVIM_APPNAME=lazynvim nvim"

## Config
abbr --add bri "brew info"
abbr --add brs "brew search"
abbr --add bru "brew uninstall"
abbr --add bra "brew install"

## Config
abbr --add ec "cd ~/dotfiles/.config/ && ffpn"
abbr --add ek "cd ~/dotfiles/.config/kitty/kitty.conf && ffpn"
abbr --add eg "cd ~/dotfiles/.config/ghostty && ffpn"
abbr --add ev "cd ~/dotfiles/.config/nvim && ffpn"

abbr --add ef "cd ~/dotfiles/.config/fish && ffpn"
abbr --add ew "cd ~/dotfiles/.config/wezterm/ && ffpn"
abbr --add ea "nvim ~/dotfiles/.config/fish/aliases.fish"
abbr --add src "source ~/dotfiles/.config/fish/config.fish"

# NVIM
abbr --add rmvimbuf "rm -f ~/.local/state/nvim/swap/*"
abbr --add lsvimbuf "ls ~/.local/state/nvim/swap"
abbr --add clvim "rm -rf ~/.local/state/nvim && rm -rf ~/.local/share/nvim && rm -rf ~/.cache/nvim"

# -----------------------------------------------------------------------------
# NVIM
# -----------------------------------------------------------------------------
# Alias for default config
# abbr v="nvim"

## Hammerspoon
abbr --add eh "cd ~/dotfiles/.hammerspoon && ffpn"

# Alias for LazyVim config

# NPM
alias npi="npm install"
alias npid="npm install --save-dev"
alias npr="npm run"
alias nprs="npm run start"
alias nprt="npm run test"
alias nprd="npm run dev"
alias nprb="npm run build"
alias nprsd="npm run start:dev"
alias nprsdb="npm run start:debug"
alias nprsl="npm run HOST=0.0.0.0 react-scripts start"
alias lzn="lazynpm"

# YARN
alias yi="yarn add"
alias yid="yarn add --save-dev"
alias yrd="yarn run dev"
alias yrt="yarn run test"
alias yrb="yarn run build"
alias yrsd="yarn run start:dev"

# PNPM
alias pa="pnpm add"
alias pad="pnpm add --save-dev"
alias prd="pnpm run dev"
alias prb="pnpm run build"
alias prt="pnpm run test"
alias prsd="pnpm run start:dev"
alias px="pnpx"
alias pi="pnpm install"
alias pab="pnpm approve-builds"

# Docker
abbr --add lzd lazydocker
alias dps="docker ps"
alias dcd="docker-compose down"
alias dcud="docker-compose up -d"
alias dcu="docker-compose up"
alias dco='docker container'
alias dcol='docker container ls'
alias dcola='docker container ls -a'
alias coldock='colima start --cpu 2 --memory 4 --disk 30'
alias colstop='colima stop'
alias dcro="docker container rm ollama & docker container run -d -v ollama_data:/root/.ollama -p 11434:11434 --name ollama ollama/ollama"

# Git
alias gpom="git pull origin main"
alias addssh="ssh-add ~/.ssh/git"
alias glines="git ls-files 'src/**/*.ts'  | xargs wc -l"
alias lzg="lazygit"

## shutdown
alias shd="sudo shutdown -h now"
alias rst="sudo shutdown -r now"

# Playgrounds
abbr --add jspg "cd ~/Desktop/tmp/typescript/ && nvim playground.ts"

alias desktop="cd ~/Desktop"
alias downloads="cd ~/Downloads"
alias documents="cd ~/Documents"
alias music="cd ~/Music"
alias pictures="cd ~/Pictures"

# TMP
alias tmp="cd ~/Desktop/tmp"
alias GO="cd ~/Desktop/tmp/GO"
alias RUST="cd ~/Desktop/tmp/RUST"

# PYTHON
alias python="python3"
alias activate="source ./.venv/bin/activate.fish"
alias create-django="python3 -m venv ussop && cd ussop && source ./bin/activate && pip3 install django && django-admin startproject "
alias pymigrations="python3 manage.py makemigrations"
alias pymigrate="python3 manage.py migrate"
alias start-django="python3 manage.py runserver"
alias start-app="python3 manage.py startapp main"

# NODE
alias nts="node --experimental-transform-types"

#Android Studio
alias sdkmanager="~/Library/Android/sdk/cmdline-tools/latest/bin/sdkmanager"

# Tmux
alias tn="tmux new"
alias tmls="tmux ls"
