set -g config_start_time (math (date +%s%N) / 1000000)
set -U fish_greeting

# -----------------------------------------------------------------------------
# INTERACTIVE-ONLY CONFIGURATION (Speeds up non-interactive tasks and scripts)
# -----------------------------------------------------------------------------
if status is-interactive

    # QUICK KEYMAP
    fish_vi_key_bindings
    bind -M insert -m default jk 'commandline -f repaint-mode'
    set -g fish_sequence_key_delay_ms 200

    function fish_user_key_bindings
        fish_vi_key_bindings
        bind -M insert \cf accept-autosuggestion
        bind -M insert \cp up-line
        bind -M insert \cp up-or-search
        bind -M default \cp up-or-search
        bind -M insert \cn down-line
        bind -M insert \cn down-or-search
        bind -M default \cn down-or-search
    end

    # GENERAL PATHS
    fish_add_path $HOME/.local/bin

    # General Settings
    set -gx XDG_CONFIG_HOME $HOME/.config
    set -gx EDITOR nvim
    set -gx MYVIMRC $XDG_CONFIG_HOME/nvim/init.lua
    set -gx TEALDEER_CONFIG_DIR $XDG_CONFIG_HOME/tealdeer
    set -gx VISUAL nvim

    # Source files cleanly
    if test -f $XDG_CONFIG_HOME/fish/exports.fish
        source $XDG_CONFIG_HOME/fish/exports.fish
    end
    if test -f $XDG_CONFIG_HOME/fish/aliases.fish
        source $XDG_CONFIG_HOME/fish/aliases.fish
    end
    if test -f $XDG_CONFIG_HOME/fish/functions.fish
        source $XDG_CONFIG_HOME/fish/functions.fish
    end

    # NVM
    set -gx nvm_default_version lts

    # Auto-switch & Auto-install Node version on directory change
    function __check_nvmrc --on-variable PWD --description 'Auto-switch and auto-install node version'
        status is-command-substitution; and return

        # Fast iterative upward search (stops at $HOME or root)
        set -l dir $PWD
        set -l version_file
        while true
            if test -f "$dir/.nvmrc"
                set version_file "$dir/.nvmrc"
                break
            else if test -f "$dir/.node-version"
                set version_file "$dir/.node-version"
                break
            end
            if test "$dir" = "$HOME" -o "$dir" = / -o -z "$dir"
                break
            end
            set dir (path dirname $dir)
        end

        if test -n "$version_file"
            # Only trigger switch if entering a different project
            if test "$_nvm_active_version_file" != "$version_file"
                set -g _nvm_active_version_file $version_file
                read -l req_version <"$version_file"
                set req_version (string trim -- $req_version)

                if test -n "$req_version"
                    if not nvm use --silent $req_version 2>/dev/null
                        echo "Node $req_version from $(path basename $version_file) is not installed. Installing..."
                        nvm install $req_version
                    end
                end
            end
        else if set -q _nvm_active_version_file
            # Only trigger revert when exiting a project subtree
            set -e _nvm_active_version_file
            if not nvm use --silent $nvm_default_version 2>/dev/null
                echo "Default Node version ($nvm_default_version) is not installed. Installing..."
                nvm install $nvm_default_version
            end
        end
    end

    # REMOVED: __check_nvmrc from running immediately at startup!

    # Homebrew
    fish_add_path /opt/homebrew/bin/
    set -l brew_cache "$__fish_config_dir/brew_init.fish"
    if test -f $brew_cache
        source $brew_cache
    else
        env SHELL=fish /opt/homebrew/bin/brew shellenv fish >$brew_cache
        source $brew_cache
    end

    # Zoxide (cd)
    set -l zoxide_cache "$__fish_config_dir/zoxide_init.fish"
    if test -f $zoxide_cache
        source $zoxide_cache
    else
        zoxide init fish --cmd cd >$zoxide_cache
        source $zoxide_cache
    end

    # FZF 
    set -l fzf_cache "$__fish_config_dir/fzf_init.fish"
    if test -f $fzf_cache
        source $fzf_cache
    else
        fzf --fish >$fzf_cache
        source $fzf_cache
    end

    # Starship
    set -l starship_cache "$__fish_config_dir/starship_init.fish"
    if test -f $starship_cache
        source $starship_cache
    else
        starship init fish >$starship_cache
        source $starship_cache
    end

    # Development Ecosystem Paths
    fish_add_path /opt/homebrew/opt/rustup/bin $HOME/.cargo/bin $HOME/.local/share/solana/install/active_release/bin

    set -gx GOPATH $HOME/go
    fish_add_path /usr/local/go/bin $GOPATH/bin
    fish_add_path /opt/homebrew/opt/ruby/bin /opt/homebrew/lib/ruby/gems/4.0.0/bin

    set -gx LDFLAGS -L/opt/homebrew/opt/ruby/lib
    set -gx CPPFLAGS -I/opt/homebrew/opt/ruby/include

    # Android SDK
    set -gx ANDROID_HOME $HOME/Library/Android/sdk
    set -gx ANDROID_SDK_ROOT $ANDROID_HOME

    if test -d $ANDROID_HOME/ndk
        set -l latest_ndk (ls $ANDROID_HOME/ndk | sort -V | tail -n 1)
        set -gx NDK_HOME $ANDROID_HOME/ndk/$latest_ndk
        set -gx ANDROID_NDK_HOME $NDK_HOME
    end

    set -gx JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"

    # Batched path additions
    fish_add_path $ANDROID_HOME/cmdline-tools $ANDROID_HOME/build-tools $ANDROID_HOME/platform-tools $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/emulator $JAVA_HOME/bin

    set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
    fish_add_path $HOME/.dotnet/tools /opt/homebrew/opt/gnu-tar/libexec/gnubin /opt/homebrew/opt/solana/bin/ /opt/homebrew/anaconda3/bin

    function conda --description 'Lazy-load Anaconda'
        # Delete this wrapper function so it doesn't loop
        functions -e conda

        # Run the original initialization
        eval /opt/homebrew/anaconda3/bin/conda "shell.fish" hook $argv | source

        # Forward your initial command to the real conda binary
        conda $argv
    end
    # End timer display
    set -l config_end_time (math (date +%s%N) / 1000000)
    set -l duration (math $config_end_time - $config_start_time)
    set_color cyan
    echo "The magic✨ is in the tasks I'm avoiding: $duration ms"
    set_color normal
end
