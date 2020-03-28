# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vi'
else
    export EDITOR='vim'
fi

export BAT_PAGER="less -R"
export BAT_THEME="Monokai Extended"