alias zshconfig="code ~/.zshrc"

alias htop="sudo htop -t"

alias gpr="ggpur"
alias gs="gst"
alias pe="path-extractor"

cdwhich() {
    cd ${$(which $1):a:h}
}

pl() {
    set -x
    pluginator $1 rcp-fe-lol-$2 --env ci $@[3,-1]
    set +x
}

loop() {
    for x in {1..$1}; do $@[2,-1]; done
}
alias brewup="brew update; brew upgrade; brew cleanup; brew doctor"

unalias fd

p10k-colors() {
    for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}