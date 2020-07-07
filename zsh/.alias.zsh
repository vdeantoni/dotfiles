alias zshconfig="code ~/.zshrc"

alias gpr="ggpur"
alias gs="gst"

alias pe="path-extractor"

alias brewup="brew update; brew upgrade; brew cleanup; brew doctor"

alias -g Z='| fzf'

alias lg='lazygit'

alias v='nvim'
alias vim='v'
alias vi='v'

alias tolower="tr '[:upper:]' '[:lower:]'"
alias toupper="tr '[:lower:]' '[:upper:]'"

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

alias '?'='google'

alias shuf="rl"

# remove undesired aliases
unalias fd
unalias ff

# helper functions
displays() {
    system_profiler SPDisplaysDataType
}

diffstring() {
    diff <(echo $1) <(echo $2)
}

classnames() {
    local in=$1
    [[ -z "$in" ]] && read in

    echo \"$(echo $in | sed 's/  / /g' | sed 's/ /", "/g')\"
}

cn() {
    local in=$1
    [[ -z "$in" ]] && read in

    classnames $1 | pbcopy
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