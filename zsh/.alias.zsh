alias zshconfig="code ~/.zshrc"
alias htop="sudo htop -t"

alias gpr="ggpur"
alias gs="gst"

alias pe="path-extractor"
alias brewup="brew update; brew upgrade; brew cleanup; brew doctor"

alias -g F='| fzf'

# remove undesired aliases
unalias fd
unalias ff

# helper functions
cdwhich() {
    cd $(dirname $(which $1))
}

cdparent() {
    cd $(dirname $1)
}

loop() {
    for x in {1..$1}; do $@[2,-1]; done
}

p10k-colors() {
    for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}