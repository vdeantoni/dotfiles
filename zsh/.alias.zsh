alias zshconfig="code ~/.zshrc"

alias gpr="ggpur"
alias gs="gst"

alias pe="path-extractor"
alias brewup="brew update; brew upgrade; brew cleanup; brew doctor"

alias -g Z='| fzf'

alias lg='lazygit'

# alias v='nvim'
# alias vim='v'
# alias vi='v'

# remove undesired aliases
unalias fd
unalias ff

# helper functions
classnames() {
    local in=$1
    if [ -z "$in" ]
    then
        read in;
    fi

    echo \"$(echo $in | sed 's/  / /g' | sed 's/ /", "/g')\"
}

cdwhich() {
    cd $(dirname $(which $1))
}

cdparent() {
    cd $(dirname $1)
}

stat-octal() {
    stat -f %Mp%Lp $1
}

loop() {
    for x in {1..$1}; do $@[2,-1]; done
}

ansi-colors() {
    for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}