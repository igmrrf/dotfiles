if status is-interactive
    # Commands to run in interactive sessions can go here
    echo "Welcome back, time to build some boring stuff"
end
set -U fish_greeting

# -----------------------------------------------------------------------------
# GENERAL PATHS
# -----------------------------------------------------------------------------
fish_add_path $HOME/.local/bin

# -----------------------------------------------------------------------------
# General Settings
# -----------------------------------------------------------------------------
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR nvim
set -gx MYVIMRC $XDG_CONFIG_HOME/nvim/init.lua
set -gx TEALDEER_CONFIG_DIR $XDG_CONFIG_HOME/tealdeer
set -gx VISUAL nvim

# source functions
if test -f $XDG_CONFIG_HOME/fish/exports.fish
    source $XDG_CONFIG_HOME/fish/exports.fish
end
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

# NVM
set --universal nvm_default_version v24.13.1
set -gx NVM_DEFAULT_VERSION v24.13.1
# For yarn
set -gx FNM_COREPACK_ENABLED true

function __check_nvmrc --on-variable PWD --description 'Auto-switch node version based on .nvmrc'
    # Do not run in background jobs or command substitutions
    status --is-command-substitution; and return

    if test -f .nvmrc
        set -l nvmrc_version (cat .nvmrc)
        set -l current_version (nvm current)

        if test "$nvmrc_version" != "$current_version"
            nvm use
        end
    else if test (nvm current) != $NVM_DEFAULT_VERSION
        # Revert to default if no .nvmrc is found and we aren't on default
        echo "Reverting to nvm default version"
        nvm use default
    end
end

__check_nvmrc

# Homebrew
fish_add_path /opt/homebrew/bin/

/opt/homebrew/bin/brew shellenv | source

# Rust
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.cargo/env.fish
fish_add_path $HOME/.local/share/solana/install/active_release/bin

# Go
set -Ux GOPATH $HOME/go

fish_add_path /usr/local/go/bin
fish_add_path $GOPATH/bin

# Ruby
fish_add_path /opt/homebrew/opt/ruby/bin

# By default, binaries installed by gem will be placed into:
fish_add_path /opt/homebrew/lib/ruby/gems/4.0.0/bin

# For compilers to find ruby:
set -gx LDFLAGS -L/opt/homebrew/opt/ruby/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/ruby/include

# Android SDK
set -gx ANDROID_HOME $HOME/Library/Android/sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME

# NDK (Automatically finds the latest version folder)
if test -d $ANDROID_HOME/ndk
    set -l latest_ndk (ls $ANDROID_HOME/ndk | sort -V | tail -n 1)
    set -gx NDK_HOME $ANDROID_HOME/ndk/$latest_ndk
    set -gx ANDROID_NDK_HOME $NDK_HOME
end

# Java Home (Using the JetBrains Runtime bundled with Android Studio)
set -gx JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"

# Update PATH for fish_user_paths (Fish's preferred way to manage PATH)
fish_add_path $ANDROID_HOME/cmdline-tools
fish_add_path $ANDROID_HOME/build-tools
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/emulator
fish_add_path $JAVA_HOME/bin

# source aliases
if test -f $XDG_CONFIG_HOME/fish/aliases.fish
    source $XDG_CONFIG_HOME/fish/aliases.fish
end

# source functions
if test -f $XDG_CONFIG_HOME/fish/functions.fish
    source $XDG_CONFIG_HOME/fish/functions.fish
end

# Dotnet
fish_add_path $HOME/.dotnet/tools

fish_add_path /opt/homebrew/opt/gnu-tar/libexec/gnubin
fish_add_path /opt/homebrew/opt/solana/bin/

# Zoxide (cd)
zoxide init fish --cmd cd | source

# FZF 
fzf --fish | source

# Starfish
starship init fish | source

# Added by Antigravity
fish_add_path /Users/igmrrf/.antigravity/antigravity/bin

# Added by Antigravity
fish_add_path /Users/igmrrf/.antigravity/antigravity/bin
